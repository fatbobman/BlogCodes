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
    let highlightColor: Color
    let currentHighlightColor: Color

    init(
        showSearchBar: Bool = false,
        highlightColor: Color? = nil,
        currentHighlightColor: Color? = nil
    ) {
        self.showSearchBar = showSearchBar
        self.highlightColor = highlightColor ?? .cyan.opacity(0.3)
        self.currentHighlightColor = currentHighlightColor ?? .yellow.opacity(0.7)
    }

    var body: some View {
        VStack {
            ScrollViewReader { scrollProxy in
                if store.transcriptions.isEmpty {
                    ProgressView()
                } else {
                    List(store.transcriptions) { transcription in
                        TranscriptionRow(
                            transcription: transcription,
                            store: store,
                            highlightColor: highlightColor,
                            currentHighlightColor: currentHighlightColor,
                            bold: false,
                            link: true
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
                    .environment(\.openURL, OpenURLAction { url in
                        switch url.scheme {
                        case positionScheme:
                            if let host = url.host(), let position = Int(host) {
                                store.scrollToPosition(position)
                            }
                            return .handled
                        default:
                            return .systemAction
                        }
                    })
                }
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
        .task {
            await store.loadData(amount: 1000)
        }
        .navigationTitle("Search Demo")
    }
}

extension TranscriptionRoot {
    private func dismissSearchBar() {
        store.reset()
        showSearchBar = false
    }

    @ToolbarContentBuilder
    var searchButton: some ToolbarContent {
        ToolbarItem {
            Button {
                showSearchBar = true
            } label: {
                if !showSearchBar {
                    Image(systemName: "magnifyingglass") // 􀊫
                }
            }
        }
    }

    @ViewBuilder
    var safeSearchBar: some View {
        SearchBar(
            store: store,
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
        TranscriptionRoot(showSearchBar: true)
    }
}
