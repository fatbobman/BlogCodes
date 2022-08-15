//
//  SymbolInText.swift
//  InlineImageWithText
//
//  Created by Yang Xu on 2022/8/13.
//

import Foundation
import SwiftUI

struct SymbolInTextView: View {
    @State private var value: Double = 0
    private let message = Image(systemName: "message.badge.filled.fill") // 􁋭
        .renderingMode(.original)
    private let wifi = Image(systemName: "wifi") // 􀙇
    private var animatableWifi: Image {
        Image(systemName: "wifi", variableValue: value)
    }

    var body: some View {
        VStack(spacing:50) {
            VStack {
                Text(message).font(.title) + Text("文字与 SF Symbols 混排。\(wifi) Text 会将插值图片视作文字的一部分。") + Text(animatableWifi).foregroundColor(.blue)
            }

            // 使用 TextBuilder 创建相同的内容
            textBuilder()
                .environment(\.sizeCategory, .accessibilityExtraExtraLarge)
        }
        .task(changeVariableValue)
        .frame(width:300)
    }

    @Sendable
    func changeVariableValue() async {
        while !Task.isCancelled {
            if value >= 1 { value = 0 }
            try? await Task.sleep(nanoseconds: 1000000000)
            value += 0.25
        }
    }

    @TextBuilder
    func textBuilder() -> Text {
        Text(message)
            .font(.title)
        Text("文字与 Symbol 混排。\(wifi) Text 会将插值图片视作文字的一部分。")
        Text(animatableWifi)
            .foregroundColor(.red)
    }
}

struct SymbolInTextView_Preview: PreviewProvider {
    static var previews: some View {
        SymbolInTextView()
            .previewLayout(.fixed(width: 300, height: 200))
    }
}

@resultBuilder
enum TextBuilder {
    static func buildBlock(_ components: Text...) -> Text {
        components.reduce(Text(""),+)
    }
}
