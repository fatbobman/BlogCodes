//
//  ContentView.swift
//  SyncManager
//
//  Created by Yang Xu on 2022/7/21.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var store: Store
    @FetchRequest(
        sortDescriptors: [SortDescriptor(\.timestamp, order: .reverse)],
        animation: .easeInOut
    ) var items: FetchedResults<Item>
    @AppStorage(enableCloudMirrorKey) var enable = false
    var body: some View {
        NavigationView {
            List(items) { item in
                Text(item.timestamp ?? .now, format: .dateTime.month().day().hour().minute().second(.twoDigits))
                    .swipeActions {
                        Button(role: .destructive, action: {
                            store.delItem(item.objectID)
                        }, label: {
                            Image(systemName: "trash")
                        })
                    }
            }
            .toolbar {
                ToolbarItem {
                    Button {
                        store.newItem()
                    } label: {
                        Image(systemName: "plus.circle")
                    }
                }
                ToolbarItem(placement: .principal) {
                    Toggle(isOn: $enable) {
                        Text("同步")
                    }
                    .toggleStyle(.switch)
                    .frame(width: 100)
                    .onChange(of: enable) { _ in
                        if enable {
                            store.stack.setCloudContainer()
                        } else {
                            store.stack.removeCloudContainer()
                        }
                    }
                }
            }
        }
        .navigationViewStyle(.stack)
    }
}

struct ContentView_Previews: PreviewProvider {
    static let store = Store()
    static var previews: some View {
        ContentView()
            .environmentObject(store)
            .environment(\.managedObjectContext, store.stack.viewContext)
    }
}
