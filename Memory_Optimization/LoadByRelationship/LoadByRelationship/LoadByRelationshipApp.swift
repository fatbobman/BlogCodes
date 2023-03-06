//
//  LoadByRelationshipApp.swift
//  LoadByRelationship
//
//  Created by Yang Xu on 2023/3/7.
//

import SwiftUI

@main
struct LoadByRelationshipApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
