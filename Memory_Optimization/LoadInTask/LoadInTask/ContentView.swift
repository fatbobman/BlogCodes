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

    @State var memory: Float = 0

    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Text("记录数: \(items.count)")
                    Text("内存占用: ") + Text(memory, format: .number.precision(.fractionLength(1)))
                        .foregroundColor(.red)
                        .bold()
                }
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
        .task {
            for await _ in Timer.publish(every: 0.3, on: .main, in: .common).autoconnect().values {
                memory = reportMemory()
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

func reportMemory() -> Float {
    var taskInfo = task_vm_info_data_t()
    var count = mach_msg_type_number_t(MemoryLayout<task_vm_info>.size) / 4
    let _: kern_return_t = withUnsafeMutablePointer(to: &taskInfo) {
        $0.withMemoryRebound(to: integer_t.self, capacity: 1) {
            task_info(mach_task_self_, task_flavor_t(TASK_VM_INFO), $0, &count)
        }
    }
    let usedMb = Float(taskInfo.phys_footprint) / 1048576.0
    return usedMb
}
