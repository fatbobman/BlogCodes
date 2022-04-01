import Foundation
import PlaygroundSupport
import SwiftUI

@AttributedTextBuilder
var attributedText: AttributedText {
    // 类似 SwiftUI 的 Group
    Container {
        "Hello "
            .localized()
            .color(.red)
            .bold()

        "~World~"
            .localized()
    }
    .color(.green)
    .italic()

    // 新段落
    Paragraph {
        for i in 0..<10 {
            " \(i) "
        }
    }

    "[肘子的Swift记事本](https://www.fatbobman.com)"
        .localized()
}

let text = Text(attributedText.content)

PlaygroundPage
    .current
    .setLiveView(
        text
            .frame(width: 200, height: 100)
    )
