//
//  DefaultUsingTopAndBottomID.swift
//  FetchRequestDemo
//
//  Created by Yang Xu on 2022/4/21
//  Copyright © 2022 Yang Xu. All rights reserved.
//
//  Follow me on Twitter: @fatbobman
//  My Blog: https://www.fatbobman.com
//

import Foundation
import SwiftUI

struct ListOnlyTopAndBottomHasID: View {
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default
    )
    private var items: FetchedResults<Item>

    @State var showLastOne = false
    var body: some View {
        ScrollViewReader { proxy in
            VStack {
                HStack {
                    Button("Top") {
                        withAnimation {
                            proxy.scrollTo("top", anchor: .center)
                        }
                    }.buttonStyle(.bordered)
                    Button("Bottom") {
                        withAnimation {
                            proxy.scrollTo("bottom")
                        }
                    }.buttonStyle(.bordered)
                }
                List {
                    TopCell()
                        .id("top")
                        .listRowSeparator(.hidden)
                    ForEach(items) { item in
                        ItemRow(item: item)
//                            .conditionID(id: item.objectID, condition: item.objectID == items.last?.objectID)
                    }
                    BottomCell()
                        .id("bottom")
                        .listRowSeparator(.hidden)
                }
                .environment(\.defaultMinListRowHeight, 0)
            }
        }
        .navigationTitle("默认")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            Button("Info") {
                showLastOne.toggle()
            }
        }
        .sheet(isPresented: $showLastOne, content: { info() })
        .onAppear {
            print(Date().timeIntervalSince(Timer.demo3))
        }
    }

    func info() -> some View {
        let faultCount = items.filter { $0.isFault }.count
        return VStack {
            Text("item's count: \(items.count)")
            Text("fault item's count : \(faultCount)")
        }
    }
}

struct TopCell: View {
    init() { print("top cell init") }
    var body: some View {
        Text("Top")
            .frame(width: 0, height: 0)
    }
}

struct BottomCell: View {
    init() { print("bottom cell init") }
    var body: some View {
        Text("Bottom")
            .frame(width: 0, height: 0)
    }
}

extension View {
    @ViewBuilder
    func conditionID<ID: Hashable>(id: ID, condition: @autoclosure () -> Bool) -> some View {
        if condition() {
            self.id(id)
        } else {
            self
        }
    }
}
