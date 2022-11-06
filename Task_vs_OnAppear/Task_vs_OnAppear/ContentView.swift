//
//  ContentView.swift
//  Task_vs_OnAppear
//
//  Created by Yang Xu on 2022/9/26.
//

import SwiftUI

struct ContentView: View {
    @StateObject var store = Store()
    var body: some View {
        VStack {
            Button("Change ID") { store.id = UUID() }
//            ScrollView {
//                LazyVGrid(columns: [GridItem(.fixed(200))]) {
            List{
                    ForEach(0..<100) { index in
                        SubView(index: index, store: store, localIndexByOnChange: index, localIndexByTask: index)
                    }
//                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct SubView: View {
    let index: Int
    @ObservedObject var store: Store
    @State var localIndexByOnChange: Int
    @State var localIndexByTask: Int
    @State var viewLoaded = false
    var body: some View {
        VStack(alignment: .leading) {
            Text("index: \(index)")
            Text("by onChange: \(localIndexByOnChange)")
            Text("by task: \(localIndexByTask)")
        }
        .onAppear { print("\(index) appear") }
//        .onDisappear { print("\(index) disappear") }
//        .onChange(of: store.id) { _ in
//            print("by onChange: \(index) detected that id has changed")
//            localIndexByOnChange = Int.random(in: 1000...100000000)
//        }
//        .task(id: store.id) {
//            print("task \(index) onChange ...")
//            if viewLoaded {
//                localIndexByTask = Int.random(in: 1000...100000000)
//            } else {
//                viewLoaded = true
//            }
//            print("by task: \(index) detected that id has changed")
//        }
        .task {
            print("task \(index)  start")
//            while !Task.isCancelled {
//                try? await Task.sleep(nanoseconds: 1000000000)
//            }
//            print("task \(index) stop")
        }
    }
}

class Store: ObservableObject {
    @Published var id = UUID()
}
