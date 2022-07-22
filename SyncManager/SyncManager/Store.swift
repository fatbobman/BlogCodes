//
//  Store.swift
//  SyncManager
//
//  Created by Yang Xu on 2022/7/21.
//

import CoreData
import Foundation
import SwiftUI

final class Store: ObservableObject {
    let stack = CoreDataStack(modelName: "Model")

    func newItem() {
        stack.newItem()
    }

    func delItem(_ id: NSManagedObjectID) {
        stack.delItem(ObjectID: id)
    }
}
