//
//  Item.swift
//  SwiftDataChangeMonitor
//
//  Created by Yang Xu on 2023/10/27.
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
