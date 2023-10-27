//
//  SwiftDataChangeMonitorApp.swift
//  SwiftDataChangeMonitor
//
//  Created by Yang Xu on 2023/10/27.
//

import SwiftUI
import SwiftData

@main
struct SwiftDataChangeMonitorApp: App {
    let dataProvider = DataProvider.share
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(dataProvider.container)
    }
}
