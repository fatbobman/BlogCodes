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
//            TestView()
//            MemeoryReleaseDemoByState()
//            MemeoryReleaseDemoByStateObject()
        }
    }
}

import CoreData

// 测试.只适用于当 Picture 的 data 属性为外部存储
struct TestView: View {
    @State var pictures1 = [Picture]()
    @State var pictures2 = [Picture]()
    @State var memory: Float = 0
    let fetchRequest: NSFetchRequest<Picture> = {
        let fetchRequest = NSFetchRequest<Picture>(entityName: "Picture")
        fetchRequest.sortDescriptors = []
        fetchRequest.returnsObjectsAsFaults = false
        return fetchRequest
    }()

    var body: some View {
        VStack {
            Text("Memory: \(memory, format: .number.precision(.fractionLength(2)))")
            HStack {
                Button("Load Picture1") {
                    let context = PersistenceController.shared.container.viewContext
                    pictures1 = (try? context.fetch(fetchRequest)) ?? []
                    memory = reportMemory()
                }
                Button("Release") {
                    pictures1 = []
                }
            }
            HStack {
                Button("Load Picture2") {
                    let context = PersistenceController.shared.container.newBackgroundContext()
                    context.performAndWait {
                        pictures2 = (try? context.fetch(fetchRequest)) ?? []
                    }
                    memory = reportMemory()
                }
                Button("Release") {
                    pictures2 = []
                }
            }
        }
        .buttonStyle(.borderedProminent)
    }
}

struct MemeoryReleaseDemoByState: View {
    @State var data: Data?
    @State var memory: Float = 0
    var body: some View {
        VStack {
            Text("memory :\(memory)")
            Button("Generate Data") {
                data = Data(repeating: 0, count: 10000000)
                memory = reportMemory()
            }
            Button("ReleaseMemory") {
                data = nil
                memory = reportMemory()
            }
        }
        .onAppear{
            memory = reportMemory()
        }
    }
}

struct MemeoryReleaseDemoByStateObject: View {
    @StateObject var holder = Holder()
    @State var memory: Float = 0
    var body: some View {
        VStack {
            Text("memory :\(memory)")
            Button("Generate Data") {
                holder.data = Data(repeating: 0, count: 10000000)
                memory = reportMemory()
            }
            Button("ReleaseMemory") {
                holder.data = nil
                memory = reportMemory()
            }
        }
        .onAppear{
            memory = reportMemory()
        }
    }
    
    class Holder:ObservableObject {
        @Published var data:Data?
    }
}
