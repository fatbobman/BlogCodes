//
//  ContentView.swift
//  LoadInTask
//
//  Created by Yang Xu on 2023/3/6.
//

import CoreData
import SwiftUI

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>

    var body: some View {
        NavigationView {
            VStack {
                Text(items.count, format: .number)
                List {
                    ForEach(items) { item in
                        ItemCell(item: item)
                    }
                }
                .toolbar {
                    ToolbarItem {
                        Button(action: addItem) {
                            Text("Add 100")
                        }
                    }
                }
            }
        }
    }

    private func addItem() {
        Task {
            let context = PersistenceController.shared.container.newBackgroundContext()
            await context.perform {
                for i in 0 ..< 100 {
                    let newItem = Item(context: context)
                    newItem.timestamp = Date()
                    let picture = Picture(context: context)
                    picture.data = UIImage(named: "baby")!.pngData()
                    newItem.picture = picture
                    print("generate item \(i)")
                }
                do {
                    try context.save()
                    print("100 items saved")
                } catch {
                    // Replace this implementation with code to handle the error appropriately.
                    // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    let nsError = error as NSError
                    fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
