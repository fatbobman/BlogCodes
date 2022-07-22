//
//  SyncManagerApp.swift
//  SyncManager
//
//  Created by Yang Xu on 2022/7/21.
//

import SwiftUI

@main
struct SyncManagerApp: App {
    @StateObject var store = Store()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, store.stack.viewContext)
                .environmentObject(store)
        }
    }
}
