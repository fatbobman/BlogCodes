//
//  SwiftDataModel.swift
//  ToManyPerformance
//
//  Created by Yang Xu on 2024/1/8.
//

import Foundation
import SwiftData

@Model
public final class Item {
    public var timestamp: Date
    public var tags: [Tag]?
    public init(timestamp: Date) {
        self.timestamp = timestamp
    }
}

@Model public class Tag {
    public var name: String
    public var item: Item?
    public init(name: String) {
        self.name = name
    }
}

// For non inverse test
@Model
public final class Item_NoInverse {
    public var timestamp: Date
    public var tags: [Tag_NoInverse] = []
    public init(timestamp: Date) {
        self.timestamp = timestamp
    }
}

@Model public class Tag_NoInverse {
    public var name: String
    public var item: Item_NoInverse?
    public init(name: String) {
        self.name = name
    }
}
