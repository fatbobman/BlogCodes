//
//  SearchResults.swift
//  ShowKeywordsInText
//
//  Created by Yang Xu on 2022/8/18.
//

import Combine
import Foundation

final class Store: ObservableObject {
    @Published var count: Int
    @Published var rangeResult: [UUID: [TranscriptionRanges]]
    @Published var currentPosition: Int?
    @Published var positionProxy: [Int: UUID]
    @Published var transcriptions: [Transcription]
    @Published var keyword: String

    private var cancellable: AnyCancellable?

    private var searching = false

    init(
        count: Int = 0,
        rangeResult: [UUID: [TranscriptionRanges]] = [:],
        currentPosition: Int? = nil,
        positionProxy: [Int: UUID] = [:],
        transcriptions: [Transcription] = [],
        keyword: String = ""
    ) {
        self.count = count
        self.rangeResult = rangeResult
        self.currentPosition = currentPosition
        self.positionProxy = positionProxy
        self.transcriptions = transcriptions
        self.keyword = keyword
        cancellable = $keyword
            .removeDuplicates()
            .throttle(for: .seconds(0.1), scheduler: DispatchQueue.main, latest: true) // 如果数据量很大，可以调整 debounce 缓解性能压力
            .task(maxPublishers: .max(1)) { keyword in
                await self.search(keyword: keyword)
            }
            .emptySink()
    }

    var currentID: UUID? {
        guard let currentPosition else { return nil }
        return positionProxy[currentPosition]
    }

    @MainActor
    func reset() {
        rangeResult.removeAll()
        currentPosition = nil
        positionProxy.removeAll()
        count = 0
        keyword = ""
    }

    func getKeywordsResult(for transcriptionID: UUID) -> KeywordsResult? {
        guard let rangeResult = rangeResult[transcriptionID] else { return nil }
        let position = rangeResult.map(\.position).contains(currentPosition ?? -1) ? currentPosition : nil
        return .init(currentPosition: position, transcriptionRanges: rangeResult)
    }

    func gotoPrevious() {
        if let currentPosition, currentPosition > 0 {
            self.currentPosition = currentPosition - 1
        }
    }

    func gotoNext() {
        if let currentPosition, currentPosition < count - 1 {
            self.currentPosition = currentPosition + 1
        }
    }

    @MainActor
    func scrollToPosition(_ position: Int) {
        if position >= 0, position < count - 1 {
            self.currentPosition = position
        }
    }

    @Sendable
    func search(keyword: String) async {
        guard !keyword.isEmpty else {
            await reset()
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
            await setSearchResult(rangeResult: rangeResult, positionProxy: positionProxy, count: count)
        }
    }

    @MainActor
    private func setSearchResult(rangeResult: [UUID: [TranscriptionRanges]], positionProxy: [Int: UUID], count: Int) {
        self.rangeResult = rangeResult
        self.positionProxy = positionProxy
        self.count = count
        self.currentPosition = count == 0 ? nil : 0
    }

    @Sendable
    func loadData(amount: Int) async {
        let sampleData = await prepareSampleData(amount: amount)
        await MainActor.run {
            self.transcriptions = sampleData
        }
    }

    @Sendable
    private func prepareSampleData(amount: Int) async -> [Transcription] {
        var result: [Transcription] = []
        (0..<amount).forEach { _ in
            let sentence = sampleSentence.randomElement() ?? ""
            let min = Int.random(in: 1...59).formatted(.number.precision(.integerLength(2)))
            let sec = Int.random(in: 1...59).formatted(.number.precision(.integerLength(2)))
            let timestamp = min + ":" + sec
            result.append(.init(startTime: timestamp, context: sentence))
        }
        return result
    }
}
