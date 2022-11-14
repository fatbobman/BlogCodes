//
//  ContentView.swift
//  DynamicNavigationContainer
//
//  Created by Yang Xu on 2022/11/12.
//

import SwiftUI

struct ThreeColumnsView: View {
    @StateObject var store = ThreeStore()
    @State var visible = NavigationSplitViewVisibility.all
    var body: some View {
        VStack {
            NavigationSplitView(columnVisibility: $visible, sidebar: { // 无法自定义选中效果
                List(selection: Binding<Int?>(get: { store.contentID }, set: {
                    store.contentID = $0
                    store.detailID = nil
                })) {
                    ForEach(0..<100) { i in
                        Text("SideBar \(i)")
                    }
                }
                .id(store.deselectSeed)
            }, content: {
                List(selection: $store.detailID) {
                    if let contentID = store.contentID {
                        ForEach(0..<100) { i in
                            Text("\(contentID):\(i)")
                        }
                    }
                }
                .id(store.contentID)
                .overlay {
                    if store.contentID == nil {
                        Text("Empty")
                    }
                }
            }, detail: {
                if let detailID = store.detailID {
                    Text("\(detailID)")
                } else {
                    Text("Empty")
                }
            })
            .navigationSplitViewStyle(.balanced)
            HStack {
                Button("Back Root") {
                    store.backRoot()
                }
                Button("Back Parent") {
                    store.backParent()
                }
            }
            .buttonStyle(.bordered)
        }
    }
}

class ThreeStore: ObservableObject {
    @Published var contentID: Int?
    @Published var detailID: Int?
    @Published var deselectSeed = 0

    func backParent() {
        if detailID != nil {
            detailID = nil
        } else if contentID != nil {
            contentID = nil
        }
    }

    func backRoot() {
        detailID = nil
        contentID = nil
        // 改善 compact 模式下返回根目录后的表现。取消选中高亮
        // 可以用类似的方式，改善当 contentID 变化后，content 列仍会有灰色选择提示的问题
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            withAnimation {
                self.deselectSeed += 1
            }
        }
    }
}
