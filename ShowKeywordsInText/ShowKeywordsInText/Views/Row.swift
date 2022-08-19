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
    let link: Bool

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

struct TranscriptionRow_Preview:PreviewProvider{
    static var previews: some View{
        TranscriptionRow(
            transcription: .init(startTime: "08:20", context: content ),
            ranges: transcriptionRanges,
            highlightColor: .cyan.opacity(0.3),
            currentHighlightColor: .yellow.opacity(0.7),
            bold: true,
            link: true
        )
        .padding()
    }

    static let content = "The following example shows a text field to accept a username, and a text view below it that shadows the continuously updated value of text username. "
    static var ranges:[Range<String.Index>] {
        content.ranges(of: "text")
    }

    static var transcriptionRanges:KeywordsResult{
        let tr = ranges.enumerated().map{
            TranscriptionRanges(position: $0.offset, range: $0.element)
        }
        return .init(currentPosition: 1, transcriptionRanges: tr)
    }
}
