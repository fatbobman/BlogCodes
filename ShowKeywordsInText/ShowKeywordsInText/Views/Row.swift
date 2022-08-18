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

    var body: some View {
        VStack(alignment: .leading) {
            Text(transcription.startTime).font(.caption2).padding(.vertical, 2)
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
                    text[lowerBound..<upperBound].swiftUI.backgroundColor = .orange.opacity(0.3)
                } else {
                    text[lowerBound..<upperBound].swiftUI.backgroundColor = .cyan.opacity(0.3)
                }
            }
        }

        return Text(text)
    }
}
