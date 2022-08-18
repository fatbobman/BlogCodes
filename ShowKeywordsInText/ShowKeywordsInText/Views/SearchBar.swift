//
//  SearchBar.swift
//  ShowKeywordsInText
//
//  Created by Yang Xu on 2022/8/18.
//

import Foundation
import SwiftUI

struct SearchBar: View {
    @Binding var keyword: String
    let currentPosition: Int?
    let count: Int
    var next: () -> Void
    var previous: () -> Void
    var reset: () -> Void
    var search: (String) async -> Void
    var dismiss: () -> Void

    @State private var searching = false
    @FocusState private var focused: Bool

    var body: some View {
        HStack {
            dismissButton
            HStack {
                TextField("查找", text: $keyword)
                    .focused($focused)
                    .padding(.horizontal, 5)
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
        if !keyword.isEmpty {
            Button {
                keyword = ""
                reset()
            }
            label: {
                Image(systemName: "plus.circle.fill")
                    .rotationEffect(.degrees(45))
                    .foregroundColor(.secondary)
            }
            .buttonStyle(.plain)
        }
    }

    @ViewBuilder
    var positionText: some View {
        if let currentPosition, count > 0 {
            VStack {
                Text(currentPosition + 1, format: .number) + Text("/") + Text(count, format: .number)
            }
            .foregroundColor(.secondary)
        }
    }

    @ViewBuilder
    var nextButton: some View {
        Button {
            next()
        }
    label: {
            Image(systemName: "chevron.down")
            .foregroundColor((currentPosition ?? 0) >= count - 1 ? .secondary :.primary)
        }
        .disabled((currentPosition ?? 0) >= count - 1)
    }

    @ViewBuilder
    var previousButton: some View {
        Button {
            previous()
        }
    label: {
            Image(systemName: "chevron.up")
            .foregroundColor(currentPosition ?? -1 <= 0 ? .secondary : .primary)
        }
        .disabled(currentPosition ?? -1 <= 0)
    }
}

struct SearchBarPreview: PreviewProvider {
    static var previews: some View {
        SearchBar(keyword: .constant("ad"), currentPosition: 0, count: 10, next: {}, previous: {}, reset: {}, search: { _ in }, dismiss: {})
            .frame(width: 300)
    }
}
