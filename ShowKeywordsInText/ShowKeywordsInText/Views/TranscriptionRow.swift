//
//  TranscriptionRow..swift
//  ShowKeywordsInText
//
//  Created by Yang Xu on 2022/8/18.
//

import Foundation
import SwiftUI

struct TranscriptionRow: View {
    let transcription: Transcription
    @ObservedObject var store: Store
    let highlightColor: Color
    let currentHighlightColor: Color
    let bold: Bool
    let link: Bool

    var body: some View {
        VStack(alignment: .leading) {
            let ranges = store.getKeywordsResult(for: transcription.id)
            Text(transcription.startTime).font(.caption).padding(.vertical, 2)
            if let ranges {
                attributedText(ranges)
            } else {
                Text(transcription.context)
            }
        }
    }

    func attributedText(_ ranges: KeywordsResult) -> some View {
        var text = AttributedString(transcription.context)
        for transcriptionRange in ranges.transcriptionRanges {
            if let lowerBound = AttributedString.Index(transcriptionRange.range.lowerBound, within: text),
               let upperBound = AttributedString.Index(transcriptionRange.range.upperBound, within: text) {
                if link {
                    text[lowerBound..<upperBound].link = URL(string: "\(positionScheme)://\(transcriptionRange.position)")
                }
                if ranges.currentPosition == transcriptionRange.position {
                    text[lowerBound..<upperBound].swiftUI.backgroundColor = currentHighlightColor
                    if bold {
                        text[lowerBound..<upperBound].foundation.inlinePresentationIntent = .stronglyEmphasized
                    }
                } else {
                    text[lowerBound..<upperBound].swiftUI.backgroundColor = highlightColor
                }
            }
        }

        return Text(text)
    }
}

let positionScheme = "goPosition"
