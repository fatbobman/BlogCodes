//
//  Item.swift
//  SwiftDataPreview
//
//  Created by Yang Xu on 2023/9/13.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
