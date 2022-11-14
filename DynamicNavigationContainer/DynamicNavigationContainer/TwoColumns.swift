//
//  TwoColumns.swift
//  DynamicNavigationContainer
//
//  Created by Yang Xu on 2022/11/12.
//

import Foundation
import SwiftUI

class TwoStore: ObservableObject {
    @Published var detailID: Int?

    func backParent() {
        detailID = nil
    }
}

struct TowColumnsView: View {
    @StateObject var store = TwoStore()
    @State var visible = NavigationSplitViewVisibility.all
    var body: some View {
        VStack {
            NavigationSplitView(columnVisibility: $visible, sidebar: {
                ScrollView {
                    LazyVStack {
                        ForEach(0..<100) { i in
                            Text("SideBar \(i)")
                                .padding(5)
                                .padding(.leading, 10)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(store.detailID == i ? Color.blue : .clear)
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    store.detailID = i
                                }
                        }
                    }
                }
                .navigationDestination(
                    isPresented: Binding<Bool>(
                        get: { store.detailID != nil },
                        set: { if !$0 { store.detailID = nil }}
                    ),
                    destination: {
                        // 需要使用独立的 struct 来构造视图
                        DetailView(store: store)
                    }
                )
            }, detail: {
                Text("Empty")
            })
            Button("Back Parent") {
                store.backParent()
            }
            .buttonStyle(.bordered)
        }
    }
}

struct DetailView: View {
    @ObservedObject var store: TwoStore
    var body: some View {
        if let detailID = store.detailID {
            Text("\(detailID)")
        }
    }
}
