//
//  SwiftDataContainer.swift
//  ToManyPerformance
//
//  Created by Yang Xu on 2024/1/8.
//

import Foundation
import SwiftData

public let sharedModelContainer: ModelContainer = {
    let schema = Schema([
        Item.self
    ])
    let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
    do {
        return try ModelContainer(for: schema, configurations: [modelConfiguration])
    } catch {
        fatalError("Could not create ModelContainer: \(error)")
    }
}()

public let non_inverse_sharedModelContainer: ModelContainer = {
    let schema = Schema([
        Item_NoInverse.self,
        Tag_NoInverse.self
    ])
    let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
    do {
        return try ModelContainer(for: schema, configurations: [modelConfiguration])
    } catch {
        fatalError("Could not create ModelContainer: \(error)")
    }
}()
