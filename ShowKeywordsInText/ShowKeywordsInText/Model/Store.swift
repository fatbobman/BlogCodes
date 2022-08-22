//
//  SearchResults.swift
//  ShowKeywordsInText
//
//  Created by Yang Xu on 2022/8/18.
//

import Combine
import Foundation

final class Store: ObservableObject {
    @Published var count: Int // 结果数量
    @Published var rangeResult: [UUID: [TranscriptionRange]] // 搜索结果 transcription.id : 结果区间和序号
    @Published var currentPosition: Int? // 当前的高亮位置
    @Published var positionProxy: [Int: UUID] // 结果序号 : transcription.id
    @Published var transcriptions: [Transcription]
    @Published var keyword: String

    var onScreenID: [UUID: Int] = [:] // 当前屏幕中正显示的 transcription ID
    var positionProxyForID: [UUID: [Int]] = [:] // transcription.id : [结果序号]

    private var cancellable: AnyCancellable?

    init(
        count: Int = 0,
        rangeResult: [UUID: [TranscriptionRange]] = [:],
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
            .throttle(for: .seconds(0.1), scheduler: DispatchQueue.main, latest: true) // 使用 debounce 可能会漏掉 keyword 的最终变化
            .task(maxPublishers: .max(1)) { keyword in
                await self.search(keyword: keyword)
            }
            .emptySink()
    }

    var currentID: UUID? { // 当前高亮所在的 transcription ID ，用于 scrollTo
        guard let currentPosition else { return nil }
        return positionProxy[currentPosition]
    }

    @MainActor
    func reset() {
        rangeResult.removeAll()
        currentPosition = nil
        positionProxy.removeAll()
        positionProxyForID.removeAll()
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
        var rangeResult: [UUID: [TranscriptionRange]] = [:]
        var positionProxy: [Int: UUID] = [:]
        var currentPosition: Int = -1
        var positionProxyForID: [UUID: [Int]] = [:]

        let regex = Regex<AnyRegexOutput>(verbatim: keyword).ignoresCase()
        for transcription in transcriptions {
            let id = transcription.id
            let ranges = transcription.context.ranges(of: regex)
            for range in ranges {
                count += 1
                currentPosition += 1
                rangeResult[id, default: []].append(.init(position: currentPosition, range: range))
                positionProxy[currentPosition] = id
                positionProxyForID[id, default: []].append(currentPosition)
            }
        }

        if !Task.isCancelled {
            await setSearchResult(rangeResult: rangeResult, positionProxy: positionProxy, positionProxyForID: positionProxyForID, count: count)
        }
    }

    @MainActor
    private func setSearchResult(rangeResult: [UUID: [TranscriptionRange]], positionProxy: [Int: UUID], positionProxyForID: [UUID: [Int]], count: Int) {
        let oleResult = self.rangeResult
        self.rangeResult = rangeResult
        self.positionProxy = positionProxy
        self.positionProxyForID = positionProxyForID
        self.count = count
        if count == 0 {
            self.currentPosition = nil
            return
        }
        if let newCurrentPosition = getCurrentPositionIfSubRangeStillExist(oldRange: oleResult, newRange: rangeResult, keyword: keyword, oldCurrentPosition: currentPosition) {
            self.currentPosition = newCurrentPosition
        } else {
            self.currentPosition = 0
        }
    }

    /// 以当前选中的关键字为优先
    private func getCurrentPositionIfSubRangeStillExist(oldRange: [UUID: [TranscriptionRange]], newRange: [UUID: [TranscriptionRange]], keyword: String, oldCurrentPosition: Int?) -> Int? {
        if let oldResult = oldRange.lazy.first(where: { $0.value.contains(where: { $0.position == oldCurrentPosition }) }),
           let oldRange = oldResult.value.first(where: { $0.position == oldCurrentPosition })?.range,
           let newResult = newRange.lazy.first(where: { $0.key == oldResult.key && $0.value.contains(where: { oldRange.overlaps($0.range) || $0.range.overlaps(oldRange) }) }),
           let newPosition = newResult.value.first(where: { oldRange.overlaps($0.range) })?.position
        {
            return newPosition
        } else {
            let nearPosition = getCurrentPositionIfInOnScreen()
            return nearPosition ?? nil
        }
    }

    /// 从List 当前显示中的 transcription 中就近选择 match 的 position
    private func getCurrentPositionIfInOnScreen() -> Int? {
        guard let midPosition = Array(onScreenID.values).mid() else { return nil }
        let idList = onScreenID.sorted(by: { (Double($0.value) - midPosition) < (Double($1.value) - midPosition) })
        guard let id = idList.first(where: { positionProxyForID[$0.key] != nil })?.key, let position = positionProxyForID[id] else { return nil }
        guard let index = transcriptions.firstIndex(where: { $0.id == id }) else { return nil }
        if Double(index) >= midPosition {
            return position.first
        } else {
            return position.last
        }
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

extension Array where Element == Int {
    func mid() -> Double? {
        guard !self.isEmpty else { return nil }
        return Double(self.reduce(0,+)) / Double(self.count)
    }
}
