//
//  ToManyPerformanceTests.swift
//  ToManyPerformanceTests
//
//  Created by Yang Xu on 2024/1/8.
//

@testable import ToManyPerformance
import XCTest

final class ToManyPerformanceCoreDataTests: XCTestCase {
    func testAddTagFromItem() throws {
        let share = PersistenceController(inMemory: true)
        let context = share.container.viewContext
        measure {
            let item = C_Item(context: context)
            item.timestamp = .now
            for i in 0 ..< 10000 {
                let tag = C_Tag(context: context)
                tag.name = "\(i)"
                item.addToTags(tag)
            }
            try? context.save()
            print(item.tags?.count ?? "null")
        }
    }

    func testAddTagFromTag() throws {
        let share = PersistenceController(inMemory: true)
        let context = share.container.viewContext
        measure {
            let item = C_Item(context: context)
            item.timestamp = .now
            for i in 0 ..< 1000 {
                let tag = C_Tag(context: context)
                tag.name = "\(i)"
                tag.item = item
            }
            try? context.save()
            print(item.tags?.count ?? "null")
        }
    }
}
