//
//  Row.swift
//  ShowKeywordsInText
//
//  Created by Yang Xu on 2022/8/18.
//

import Foundation
import SwiftUI

struct TranscriptionRow: View {
    let transcription: Transcription
    let ranges: KeywordsResult?
    let highlightColor: Color
    let currentHighlightColor: Color
    let bold: Bool

    var body: some View {
        VStack(alignment: .leading) {
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
