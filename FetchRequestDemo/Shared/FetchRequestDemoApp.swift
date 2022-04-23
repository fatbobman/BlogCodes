//
//  FetchRequestDemoApp.swift
//  Shared
//
//  Created by Yang Xu on 2022/4/21
//  Copyright © 2022 Yang Xu. All rights reserved.
//
//  Follow me on Twitter: @fatbobman
//  My Blog: https://www.fatbobman.com
//

import SwiftUI

@main
struct FetchRequestDemoApp: App {
    let persistenceController = PersistenceController.shared
    @State var hasDemoData = false
    var body: some Scene {
        WindowGroup {
            Group {
                if hasDemoData {
                    ContentView()
                        .environment(\.managedObjectContext, persistenceController.container.viewContext)
                } else {
                    CreateDemoData()
                        .task {
                            if persistenceController.itemCount() < 40000 {
                                await persistenceController.emptyItem()
                                await persistenceController.batchInsertItem()
                            }
                            hasDemoData = true
                        }
                }
            }
        }
    }
}

struct CreateDemoData: View {
    var body: some View {
        VStack {
            Text("创建演示数据")
            ProgressView()
        }
        #if os(macOS)
        .frame(minWidth: 800, minHeight: 600)
        #endif
        .scenePadding()
    }
}
