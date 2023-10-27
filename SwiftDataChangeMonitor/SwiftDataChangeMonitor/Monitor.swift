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

    private func processor(excludeAuthors: [String]) {
        let transactions = fetchTransaction()
        lastHistoryTransactionTimestamp = transactions.max { $1.timestamp > $0.timestamp }?.timestamp ?? .now
        for transaction in transactions where !excludeAuthors.contains([transaction.author ?? ""]) {
            for change in transaction.changes ?? [] {
                changeMonitor(change)
            }
        }
    }

    private func fetchTransaction() -> [NSPersistentHistoryTransaction] {
        let timestamp = lastHistoryTransactionTimestamp
        let fetchRequest = NSPersistentHistoryChangeRequest.fetchHistory(after: timestamp)
        guard let historyResult = try? modelContext.managedObjectContext?.execute(fetchRequest) as? NSPersistentHistoryResult,
              let transactions = historyResult.result as? [NSPersistentHistoryTransaction]
        else {
            return []
        }
        return transactions
    }

    private func changeMonitor(_ change: NSPersistentHistoryChange) {
        if let id = change.changedObjectID.persistentIdentifier {
            let author = change.transaction?.author ?? "unknown"
            let changeType = change.changeType
            print("author:\(author)  changeType:\(changeType)")
            print(id)
        }
    }
}



