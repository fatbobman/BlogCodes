//
//  DefaultWithID.swift
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

struct ListEachRowHasID: View {
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
                            proxy.scrollTo(items.first?.objectID, anchor: .center)
                        }
                    }.buttonStyle(.bordered)
                    Button("Bottom") {
                        withAnimation {
                            proxy.scrollTo(items.last?.objectID)
                        }
                    }.buttonStyle(.bordered)
                }
                List {
                    ForEach(items) { item in
                        ItemRow(item: item)
//                            .id(item.objectID)
                    }
                }
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
            print(Date().timeIntervalSince(Timer.demo2))
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
