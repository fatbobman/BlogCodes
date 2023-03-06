//
//  LoadInTastApp.swift
//  LoadInTast
//
//  Created by Yang Xu on 2023/3/6.
//

import SwiftUI

@main
struct LoadInTastApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
