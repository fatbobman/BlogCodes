//
//  DefaultFetchRequest.swift
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

struct ListWithoutID: View {
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default
    )
    private var items: FetchedResults<Item>

    @State var showInfo = false
    var body: some View {
        List {
            ForEach(items) { item in
                ItemRow(item: item)
            }
        }
        .navigationTitle("不支持滚动")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            Button("Info") {
                showInfo.toggle()
            }
        }
        .sheet(isPresented: $showInfo, content: { lastOne() })
        .onAppear {
            print(Date().timeIntervalSince(Timer.demo1))
        }
    }

    @ViewBuilder
    func lastOne() -> some View {
        VStack {
            Text("item's count: \(items.count)")
            if let item = items.last,
               let result = item.isFault ? "is" : "isn't" {
                Text(LocalizedStringKey("The last one **\(result)** fault"))
            }
        }
    }
}
