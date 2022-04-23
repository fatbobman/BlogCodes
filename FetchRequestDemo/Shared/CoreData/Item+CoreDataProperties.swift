//
//  Item+CoreDataProperties.swift
//  FetchRequestDemo
//
//  Created by Yang Xu on 2022/4/21
//  Copyright © 2022 Yang Xu. All rights reserved.
//
//  Follow me on Twitter: @fatbobman
//  My Blog: https://www.fatbobman.com
//

//

import CoreData
import Foundation

public extension Item {
    @nonobjc class func fetchRequest(ascending: Bool = true, batchSize: Int? = nil, returnsObjectsAsFaults: Bool = false) -> NSFetchRequest<Item> {
        let fetchRequest = NSFetchRequest<Item>(entityName: "Item")
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \Item.timestamp, ascending: ascending)]
        if let batchSize = batchSize {
            fetchRequest.fetchBatchSize = batchSize
        }
        fetchRequest.returnsObjectsAsFaults = returnsObjectsAsFaults
        return fetchRequest
    }

    @NSManaged var timestamp: Date
    @NSManaged var section: Int16
}

extension Item: Identifiable {}
