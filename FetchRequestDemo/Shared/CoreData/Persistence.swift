//
//  Persistence.swift
//  Shared
//
//  Created by Yang Xu on 2022/4/21
//  Copyright © 2022 Yang Xu. All rights reserved.
//
//  Follow me on Twitter: @fatbobman
//  My Blog: https://www.fatbobman.com
//

import CoreData
import os

final class PersistenceController {
    static let shared = PersistenceController()

    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        for _ in 0..<10 {
            let newItem = Item(context: viewContext)
            newItem.timestamp = Date()
            newItem.section = Int16.random(in: 0..<10)
        }
        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "FetchRequestDemo")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { _, error in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
        try? container.viewContext.setQueryGenerationFrom(.current)
    }

    lazy var bgContext: NSManagedObjectContext = container.newBackgroundContext()

    var viewContext: NSManagedObjectContext {
        container.viewContext
    }
}

extension PersistenceController {
    private func context(type: ContextType) -> NSManagedObjectContext {
        switch type {
        case .main:
            return viewContext
        case .background:
            return bgContext
        }
    }
}

extension PersistenceController {
    func newItem(count: Int = 1, save: Bool = true, contextType: ContextType = .main) {
        let context = context(type: contextType)
        context.perform {
            for _ in 0..<count {
                let item = Item(context: context)
                item.timestamp = .now
                item.section = Int16.random(in: 0..<10)
            }
            if save {
                context.saveIfChanged()
            }
        }
    }

    func delItem(item: Item) {
        guard let context = item.managedObjectContext else { return }
        context.perform {
            context.delete(item)
            context.saveIfChanged()
        }
    }

    func delItem(itemID: NSManagedObjectID, contextType: ContextType = .background) {
        let context = context(type: contextType)
        context.perform {
            guard let item = try? context.existingObject(with: itemID) as? Item else { return }
            self.delItem(item: item)
        }
    }

    func itemCount(contextType: ContextType = .background) -> Int {
        let context = context(type: contextType)
        var count = 0
        context.performAndWait {
            count = (try? context.count(for: Item.fetchRequest()))!
        }
        return count
    }

    func emptyItem() async {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Item")
        let emptyRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        emptyRequest.resultType = .resultTypeObjectIDs
        emptyRequest.affectedStores = bgContext.persistentStoreCoordinator?.persistentStores

        await bgContext.perform {
            do {
                let result = try self.bgContext.execute(emptyRequest)
                guard let result = result as? NSBatchDeleteResult,
                      let ids = result.result as? [NSManagedObjectID] else { return }
                let changes = [NSDeletedObjectIDsKey: ids]
                NSManagedObjectContext.mergeChanges(fromRemoteContextSave: changes, into: [self.viewContext])
            } catch {
                Logger().error("empty Item error: \(error.localizedDescription)")
            }
        }
    }

    func batchInsertItem(_ count: Int = 40000) async {
        var items: [[String: Any]] = []
        for _ in 0..<count {
            items.append(["timestamp": Date(), "section": Int16.random(in: 0..<10)])
        }
        let request = batchInsertRequest(objects: items)
        request.resultType = .objectIDs
        await bgContext.perform {
            do {
                let result = try self.bgContext.execute(request)
                guard let result = result as? NSBatchInsertResult,
                      let ids = result.result as? [NSManagedObjectID] else { return }
                let changes = [NSInsertedObjectIDsKey: ids]
                NSManagedObjectContext.mergeChanges(fromRemoteContextSave: changes, into: [self.viewContext])
            } catch {
                Logger().error("Batch insert error: \(error.localizedDescription)")
            }
        }
    }
}

extension PersistenceController {
    private func batchInsertRequest(entityName: String = "Item", objects: [[String: Any]]) -> NSBatchInsertRequest {
        let count = objects.count
        var index = 0
        return NSBatchInsertRequest(entityName: entityName, dictionaryHandler: { dict in
            guard index < count else { return true }
            dict.addEntries(from: objects[index])
            index += 1
            return false
        })
    }
}

enum ContextType {
    case main, background
}

extension NSManagedObjectContext {
    func saveIfChanged() {
        guard self.hasChanges else { return }
        do {
            try save()
        } catch {
            rollback()
            Logger().error("Save error : \(error.localizedDescription)")
        }
    }
}
