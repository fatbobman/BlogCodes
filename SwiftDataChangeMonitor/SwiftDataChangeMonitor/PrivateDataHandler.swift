//
//  PrivateDataHandler.swift
//  SwiftDataChangeMonitor
//
//  Created by Yang Xu on 2023/10/27.
//

import Foundation
import SwiftData

@ModelActor
actor PrivateDataHandler {
    func setAuthorName(name: String) {
        modelContext.managedObjectContext?.transactionAuthor = name
    }

    func newItem() {
        let item = Item(timestamp: .now)
        modelContext.insert(item)
        try? modelContext.save()
    }
}
