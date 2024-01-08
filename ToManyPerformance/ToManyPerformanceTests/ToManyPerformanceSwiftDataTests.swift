//
//  ToManyPerformanceSwiftDataTests.swift
//  ToManyPerformanceTests
//
//  Created by Yang Xu on 2024/1/8.
//

import XCTest
@testable import ToManyPerformance
import SwiftData

@MainActor
final class ToManyPerformanceSwiftDataTests: XCTestCase {

    func testAddTagFromItem() throws {
        let context = sharedModelContainer.mainContext
        measure {
            let item = Item(timestamp:.now)
            context.insert(item)
            for i in 0..<1000 {
                let tag = Tag(name: "\(i)")
                item.tags?.append(tag)
            }
            try? context.save()
            print(item.tags?.count ?? "null")
        }
    }

    func testAddTagFromTag() throws {
        let context = sharedModelContainer.mainContext
        measure {
            let item = Item(timestamp:.now)
            context.insert(item)
            for i in 0..<1000 {
                let tag = Tag(name: "\(i)")
                tag.item = item
            }
            try? context.save()
            print(item.tags?.count ?? "null")
        }
    }
    
    func testAddTagFromTagNonInverse() throws {
        let context = non_inverse_sharedModelContainer.mainContext
        measure {
            let item = Item_NoInverse(timestamp:.now)
            context.insert(item)
            for i in 0..<1000 {
                let tag = Tag_NoInverse(name: "\(i)")
                tag.item = item
            }
            try? context.save()
            print(item.tags.count)
        }
    }
    
    func testAddTagFromItemOnce() throws {
        let context = sharedModelContainer.mainContext
        measure {
            let item = Item(timestamp:.now)
            context.insert(item)
            var tags = [Tag]()
            for i in 0..<1000 {
                let tag = Tag(name: "\(i)")
                tags.append(tag)
            }
            item.tags?.append(contentsOf: tags)
            try? context.save()
            print(item.tags?.count ?? "null")
        }
    }
    
    func testAddTagFromTagByBackData() throws {
        let context = sharedModelContainer.mainContext
        let date = Date.distantPast
        measure {
            let item = Item(timestamp:date)
            context.insert(item)
            var tags = [Tag]()
            for i in 0..<1000 {
                let tag = Tag(name: "\(i)")
                context.insert(tag)
                let backingData = tag.persistentBackingData
                backingData.setValue(forKey: \.item, to: item)
            }
            try? context.save()
            print(item.tags?.count ?? "null")
        }
    }
}


