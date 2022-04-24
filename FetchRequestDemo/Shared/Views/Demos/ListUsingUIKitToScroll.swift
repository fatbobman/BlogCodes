//
//  DefaultUIKitScroll.swift
//  FetchRequestDemo
//
//  Created by Yang Xu on 2022/4/22
//  Copyright © 2022 Yang Xu. All rights reserved.
//
//  Follow me on Twitter: @fatbobman
//  My Blog: https://www.fatbobman.com
//

import Foundation
import Introspect
import SwiftUI
import UIKit

struct ListUsingUIKitToScroll: View {
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default
    )
    private var items: FetchedResults<Item>

    @State var showInfo = false
    @State var tableView: UITableView?
    var body: some View {
        VStack {
            HStack {
                Button("Top") {
                    self.tableView?.scrollToRow(at: IndexPath(item: 0, section: 0), at: .middle, animated: true)
                }.buttonStyle(.bordered)
                Button("Bottom") {
                    self.tableView?.scrollToRow(at: IndexPath(item: items.count - 1, section: 0), at: .bottom, animated: true)
                }.buttonStyle(.bordered)
            }
            List {
                ForEach(items) { item in
                    ItemRow(item: item)
                }
            }
            .introspectTableView(customize: {
                self.tableView = $0
            })
            // 实现微信对话效果
//            .onAppear {
//                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
//                    self.tableView?.scrollToRow(at: IndexPath(item: items.count - 1, section: 0), at: .bottom, animated: false)
//                }
//            }
        }
        .navigationTitle("通过UIKit方式滚动")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            Button("Info") {
                showInfo.toggle()
            }
        }
        .sheet(isPresented: $showInfo, content: { info() })
        .onAppear {
            print(Date().timeIntervalSince(Timer.demo4))
        }
    }

    @ViewBuilder
    func info() -> some View {
        VStack {
            Text("item's count: \(items.count)")
            if let item = items.last,
               let result = item.isFault ? "is" : "isn't" {
                Text(LocalizedStringKey("The last one **\(result)** fault"))
            }
        }
    }
}
