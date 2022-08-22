//
//  SearchBar.swift
//  ShowKeywordsInText
//
//  Created by Yang Xu on 2022/8/18.
//

import Foundation
import SwiftUI

struct SearchBar: View {
    @ObservedObject var store: Store
    var dismiss: () -> Void

    @State private var searching = false
    @FocusState private var focused: Bool

    var body: some View {
        HStack {
            dismissButton
            HStack {
                TextField("查找", text: $store.keyword)
                    .textInputAutocapitalization(.never)
                    .focused($focused)
                    .padding(.horizontal, 5)
                    .task {
                        focused = true
                    }
                positionText
                cancelButton
            }
            .padding(.vertical, 6.5)
            .padding(.horizontal, 5)
            .background(RoundedRectangle(cornerRadius: 10).fill(Color(uiColor: .tertiarySystemBackground)))
            previousButton
            nextButton
        }
    }
}

extension SearchBar {
    @ViewBuilder
    var dismissButton: some View {
        Button("完成") {
            focused = false
            dismiss()
        }
        .buttonStyle(.bordered)
    }

    @ViewBuilder
    var cancelButton: some View {
        if !store.keyword.isEmpty {
            Button {
                store.reset()
            }
            label: {
                Image(systemName: "plus.circle.fill") // 􀁍
                    .rotationEffect(.degrees(45))
                    .foregroundColor(.secondary)
            }
            .buttonStyle(.plain)
        }
    }

    @ViewBuilder
    var positionText: some View {
        if let currentPosition = store.currentPosition, store.count > 0 {
            VStack {
                Text(currentPosition + 1, format: .number) + Text("/") + Text(store.count, format: .number)
            }
            .foregroundColor(.secondary)
        }
    }

    @ViewBuilder
    var nextButton: some View {
        Button {
            store.gotoNext()
        }
    label: {
            Image(systemName: "chevron.down") // 􀆈
                .foregroundColor((store.currentPosition ?? 0) >= store.count - 1 ? .secondary : .primary)
        }
        .disabled((store.currentPosition ?? 0) >= store.count - 1)
    }

    @ViewBuilder
    var previousButton: some View {
        Button {
            store.gotoPrevious()
        }
    label: {
            Image(systemName: "chevron.up") // 􀆇
                .foregroundColor(store.currentPosition ?? -1 <= 0 ? .secondary : .primary)
        }
        .disabled(store.currentPosition ?? -1 <= 0)
    }
}

struct SearchBarPreview: PreviewProvider {
    static var previews: some View {
        SearchBar(store: Store(keyword: "hello world"), dismiss: {})
            .frame(width: 300)
    }
}
