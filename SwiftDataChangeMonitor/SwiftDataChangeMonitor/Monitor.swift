//
//  Monitor.swift
//  SwiftDataChangeMonitor
//
//  Created by Yang Xu on 2023/10/27.
//

import Foundation
import SwiftData
import SwiftDataKit
import Combine
import CoreData

@ModelActor
public actor DBMonitor {
    private var cancellable: AnyCancellable?
    // last history transaction timestamp
    private var lastHistoryTransactionTimestamp: Date {
        get {
            UserDefaults.standard.object(forKey: "lastHistoryTransactionTimestamp") as? Date ?? Date.distantPast
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: "lastHistoryTransactionTimestamp")
        }
    }
}

extension DBMonitor {
    // Respond to persistent history tracking notifications
    public func register(excludeAuthors: [String] = []) {
        guard let coordinator = modelContext.coordinator else { return }
        cancellable = NotificationCenter.default.publisher(
            for: .NSPersistentStoreRemoteChange,
            object: coordinator
        )
        .map { _ in () }
        .prepend(())
        .sink { _ in
            self.processor(excludeAuthors: excludeAuthors)
        }
    }

    // After receiving the notification, process the transaction
    private func processor(excludeAuthors: [String]) {
        // Get all transactions
        let transactions = fetchTransaction()
        // Save the timestamp of the latest transaction
        lastHistoryTransactionTimestamp = transactions.max { $1.timestamp > $0.timestamp }?.timestamp ?? .now
        // Filter transactions to exclude transactions generated by excludeAuthors
        for transaction in transactions where !excludeAuthors.contains([transaction.author ?? ""]) {
            for change in transaction.changes ?? [] {
                // Send transaction to processing unit
                changeHandler(change)
            }
        }
    }

    // Fetch all newly generated transactions since the last processing
    private func fetchTransaction() -> [NSPersistentHistoryTransaction] {
        let timestamp = lastHistoryTransactionTimestamp
        let fetchRequest = NSPersistentHistoryChangeRequest.fetchHistory(after: timestamp)
        // In SwiftData, the fetchRequest.fetchRequest created by fetchHistory is nil and predicate cannot be set.
        guard let historyResult = try? modelContext.managedObjectContext?.execute(fetchRequest) as? NSPersistentHistoryResult,
              let transactions = historyResult.result as? [NSPersistentHistoryTransaction]
        else {
            return []
        }
        return transactions
    }

    // Process filtered transactions
    private func changeHandler(_ change: NSPersistentHistoryChange) {
        // Convert NSManagedObjectID to PersistentIdentifier via SwiftDataKit
        if let id = change.changedObjectID.persistentIdentifier {
            let author = change.transaction?.author ?? "unknown"
            let changeType = change.changeType
            print("author:\(author)  changeType:\(changeType)")
            print(id)
        }
    }
}



