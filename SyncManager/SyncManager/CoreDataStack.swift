//
//  CoreDataStack.swift
//  SyncManager
//
//  Created by Yang Xu on 2022/7/21.
//

import CoreData
import Foundation
import PersistentHistoryTrackingKit

final class CoreDataStack {
    var cloudContainer: NSPersistentCloudKitContainer?
    lazy var container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: modelName, managedObjectModel: model)
        // enable persistent history tracking
        container.persistentStoreDescriptions.first?.setOption(true as NSNumber, forKey: NSPersistentHistoryTrackingKey)
        container.persistentStoreDescriptions.first?.setOption(true as NSNumber, forKey: NSPersistentStoreRemoteChangeNotificationPostOptionKey)
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("init persistent container error: \(error.localizedDescription)")
            }
        }
        container.viewContext.transactionAuthor = AppActor.app.rawValue
        container.viewContext.name = "viewContext"
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        container.viewContext.automaticallyMergesChangesFromParent = true
        try? container.viewContext.setQueryGenerationFrom(.current)
        persistentHistoryKit = .init(container: container,
                                     currentAuthor: AppActor.app.rawValue,
                                     allAuthors: [AppActor.app.rawValue],
                                     includingCloudKitMirroring: true,
                                     userDefaults: UserDefaults.standard,
                                     cleanStrategy: .none)
        if let url = container.persistentStoreDescriptions.first?.url {
            print("store url: \(url)")
        }
        return container
    }()

    private let model: NSManagedObjectModel
    private let modelName: String
    private var persistentHistoryKit: PersistentHistoryTrackingKit?
    var viewContext: NSManagedObjectContext {
        container.viewContext
    }

    init(modelName: String) {
        self.modelName = modelName
        // load Data Model
        guard let url = Bundle.main.url(forResource: modelName, withExtension: "momd"),
              let model = NSManagedObjectModel(contentsOf: url) else {
            fatalError("Can't get \(modelName).momd in Bundle")
        }
        self.model = model

        if UserDefaults.standard.bool(forKey: enableCloudMirrorKey) {
            setCloudContainer()
        } else {
            print("Cloud Mirror is closed")
        }
    }

    func setCloudContainer() {
        if cloudContainer != nil {
            removeCloudContainer()
        }
        let container = NSPersistentCloudKitContainer(name: modelName, managedObjectModel: model)
        container.persistentStoreDescriptions.first?.cloudKitContainerOptions = .init(containerIdentifier: cloudContainerName)
        container.persistentStoreDescriptions.first?.setOption(true as NSNumber, forKey: NSPersistentHistoryTrackingKey)
        container.persistentStoreDescriptions.first?.setOption(true as NSNumber, forKey: NSPersistentStoreRemoteChangeNotificationPostOptionKey)
        container.loadPersistentStores { _, error in
            if let error = error {
                print("Load cloud container description error:\(error.localizedDescription)")
            }
        }
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        cloudContainer = container

        // 仅首次启动时使用
//        do {
//            try container.initializeCloudKitSchema()
//        } catch {
//            print(error.localizedDescription)
//        }
    }

    func removeCloudContainer() {
        guard cloudContainer != nil else { return }
        cloudContainer = nil
        print("Turn off the cloud mirror")
    }

    func newItem() {
        container.performBackgroundTask { context in
            context.transactionAuthor = AppActor.app.rawValue
            let item = Item(context: context)
            item.timestamp = .now
            try? context.save()
        }
    }

    func delItem(ObjectID: NSManagedObjectID) {
        container.performBackgroundTask { context in
            if let object = try? context.existingObject(with: ObjectID) as? Item {
                context.delete(object)
                try? context.save()
            }
        }
    }
}
