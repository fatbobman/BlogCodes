//
//  SearchResults.swift
//  ShowKeywordsInText
//
//  Created by Yang Xu on 2022/8/18.
//

import Foundation

@MainActor
final class Store: ObservableObject {
    @Published var count: Int
    @Published var rangeResult: [UUID: [TranscriptionRanges]]
    @Published var currentPosition: Int?
    @Published var positionProxy: [Int: UUID]
    @Published var transcriptions: [Transcription]

    private var searching = false

    init(
        count: Int = 0,
        rangeResult: [UUID: [TranscriptionRanges]] = [:],
        currentPosition: Int? = nil,
        positionProxy: [Int: UUID] = [:],
        transcriptions: [Transcription] = []
    ) {
        self.count = count
        self.rangeResult = rangeResult
        self.currentPosition = currentPosition
        self.positionProxy = positionProxy
        self.transcriptions = transcriptions
    }

    var currentID: UUID? {
        guard let currentPosition else { return nil }
        return positionProxy[currentPosition]
    }

    func reset() {
        rangeResult.removeAll()
        currentPosition = nil
        positionProxy.removeAll()
        count = 0
    }

    func getKeywordsResult(for id: UUID) -> KeywordsResult? {
        guard let rangeResult = rangeResult[id] else { return nil }
        let position = rangeResult.map(\.position).contains(currentPosition ?? -1) ? currentPosition : nil
        return .init(currentPosition: position, transcriptionRanges: rangeResult)
    }

    func previous() {
        if let currentPosition, currentPosition > 0 {
            self.currentPosition = currentPosition - 1
        }
    }

    func next() {
        if let currentPosition, currentPosition < count - 1 {
            self.currentPosition = currentPosition + 1
        }
    }

    func setPostion(_ position: Int) {
        if position >= 0, position < count - 1 {
            self.currentPosition = position
        }
    }

    func setSearchResults(results: [UUID: [TranscriptionRanges]], proxy: [Int: UUID]) {
        rangeResult = results
        positionProxy = proxy
        currentPosition = 0
        count = results.count
    }

    @Sendable
    func search(keyword: String) async {
        print("start search \(keyword)")
        guard !keyword.isEmpty else {
            reset()
            return
        }
        var count = 0
        var rangeResult: [UUID: [TranscriptionRanges]] = [:]
        var positionProxy: [Int: UUID] = [:]
        var currentPosition: Int = -1

        let regex = Regex<AnyRegexOutput>(verbatim: keyword).ignoresCase()
        for transcription in transcriptions {
            let id = transcription.id
            let ranges = transcription.context.ranges(of: regex)
            for range in ranges {
                count += 1
                currentPosition += 1
                rangeResult[id, default: []].append(.init(position: currentPosition, range: range))
                positionProxy[currentPosition] = id
            }
        }

        if !Task.isCancelled {
            self.rangeResult = rangeResult
            self.positionProxy = positionProxy
            self.count = count
            self.currentPosition = count == 0 ? nil : 0
        }
        print("end search \(keyword)")
    }

    @Sendable
    func loadData() async {
        let sampleData = await prepareSampleData(amount: 200)
        await MainActor.run {
            self.transcriptions = sampleData
        }
    }

    @Sendable
    private func prepareSampleData(amount: Int) async -> [Transcription] {
        var result: [Transcription] = []
        (0..<200).forEach { _ in
            let sentence = sampleSentence.randomElement() ?? ""
            let timestamp = Int.random(in: 1...59).formatted(.number.precision(.integerLength(2))) + ":" + Int.random(in: 1...59).formatted(.number.precision(.integerLength(2)))
            result.append(.init(startTime: timestamp, context: sentence))
        }
        return result
    }
}

struct TranscriptionRanges {
    let position: Int
    let range: Range<String.Index>
}

struct KeywordsResult {
    let currentPosition: Int?
    let transcriptionRanges: [TranscriptionRanges]
}
