//
//  DataProvider.swift
//  SwiftDataChangeMonitor
//
//  Created by Yang Xu on 2023/10/27.
//

import Foundation
import SwiftData

public final class DataProvider: @unchecked Sendable {
    public var container: ModelContainer
    private var monitor: DBMonitor?

    public static let share = DataProvider(inMemory: false, enableMonitor: true)
    public static let preview = DataProvider(inMemory: true, enableMonitor: false)

    init(inMemory: Bool = false, enableMonitor: Bool = false) {
        let schema = Schema([
            Item.self,
        ])
        let modelConfiguration: ModelConfiguration
        modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: inMemory)
        do {
            let container = try ModelContainer(for: schema, configurations: [modelConfiguration])
            self.container = container
            // Set transactionAuthor of mainContext to mainApp
            Task {
                await setAuthor(container: container, authorName: "mainApp")
            }
            // Create DBMonitor to handle persistent historical tracking transactions
            if enableMonitor {
                Task.detached {
                    self.monitor = DBMonitor(modelContainer: container)
                    await self.monitor?.register(excludeAuthors: ["mainApp"])
                }
            }
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }

    @MainActor
    private func setAuthor(container: ModelContainer, authorName: String) {
        container.mainContext.managedObjectContext?.transactionAuthor = authorName
    }
}

