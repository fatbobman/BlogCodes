//
//  Publisher.swift
//  ShowKeywordsInText
//
//  Created by Yang Xu on 2022/8/19.
//

import Foundation
import Combine

// https://www.fatbobman.com/posts/combineAndAsync/

public extension Publisher {
    func task<T>(maxPublishers: Subscribers.Demand = .unlimited,
                 _ transform: @escaping (Output) async -> T) -> Publishers.FlatMap<Deferred<Future<T, Never>>, Self> {
        flatMap(maxPublishers: maxPublishers) { value in
            Deferred {
                Future { promise in
                    Task {
                        let output = await transform(value)
                        promise(.success(output))
                    }
                }
            }
        }
    }
}

public extension Publisher where Self.Failure == Never {
    func emptySink() -> AnyCancellable {
        sink(receiveValue: { _ in })
    }
}
