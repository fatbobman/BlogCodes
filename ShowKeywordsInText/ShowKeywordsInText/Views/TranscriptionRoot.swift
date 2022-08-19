//
//  ContentView.swift
//  ShowKeywordsInText
//
//  Created by Yang Xu on 2022/8/18.
//

import Combine
import SwiftUI

struct TranscriptionRoot: View {
    @StateObject private var store = Store()
    @State private var showSearchBar = false
    @State private var keyword = ""
    var body: some View {
        VStack {
            ScrollViewReader { scrollProxy in
                if store.transcriptions.isEmpty {
                    ProgressView()
                } else {
                    List(store.transcriptions) { transcription in
                        TranscriptionRow(
                            transcription: transcription,
                            ranges: store.getKeywordsResult(for: transcription.id),
                            highlightColor: .cyan.opacity(0.45),
                            currentHighlightColor: .orange.opacity(0.45),
                            bold: true
                        )
                        .id(transcription.id)
                    }
                    .onChange(of: store.currentID) { [lastID = store.currentID] currentID in
                        if lastID != currentID {
                            withAnimation {
                                scrollProxy.scrollTo(currentID, anchor: .center)
                            }
                        }
                    }
                }
            }
            .task(id: keyword) {
                await store.search(keyword: keyword)
            }
            .safeAreaInset(edge: .bottom) {
                VStack {
                    if showSearchBar {
                        safeSearchBar
                            .transition(.move(edge: .bottom).combined(with: .opacity))
                    }
                }
                .animation(.easeInOut, value: showSearchBar)
            }
        }
        .toolbar {
            searchButton
        }
        .task(store.loadData)
        .navigationTitle("Search Demo")
    }
}

extension TranscriptionRoot {
    func dismissSearchBar() {
        store.reset()
        keyword = ""
        showSearchBar = false
    }

    @ToolbarContentBuilder
    var searchButton: some ToolbarContent {
        ToolbarItem {
            Button {
                showSearchBar = true
            } label: {
                if !showSearchBar {
                    Image(systemName: "magnifyingglass")
                }
            }
        }
    }

    @ViewBuilder
    var safeSearchBar: some View {
        SearchBar(
            keyword: $keyword,
            currentPosition: store.currentPosition,
            count: store.count,
            next: store.gotoNext,
            previous: store.gotoPrevious ,
            reset: store.reset,
            search: store.search,
            dismiss: dismissSearchBar
        )
        .frame(height: 40)
        .padding(.horizontal, 20)
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 60)
        .overlay(alignment: .top) {
            Rectangle()
                .fill(Color(uiColor: .secondarySystemBackground))
                .frame(height: 1)
        }
        .ignoresSafeArea(.all)
        .background(Color(uiColor: .systemGroupedBackground).opacity(0.9))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        TranscriptionRoot()
    }
}
