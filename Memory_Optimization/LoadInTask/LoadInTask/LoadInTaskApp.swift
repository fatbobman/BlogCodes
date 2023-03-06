//
//  LoadInTaskApp.swift
//  LoadInTask
//
//  Created by Yang Xu on 2023/3/6.
//

import SwiftUI

@main
struct LoadInTaskApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
