//
//  AdaptiveDemo.swift
//  DynamicNavigationContainer
//
//  Created by Yang Xu on 2022/11/12.
//

import Foundation
import SwiftUI

class AdaptiveStore: ObservableObject {
    @Published var detailPath = [DetailInfo]() {
        didSet {
            if sizeClass == .compact, detailPath.isEmpty {
                rootID = nil
            }
        }
    }

    @Published var rootID: Int?
    var sizeClass: UserInterfaceSizeClass? {
        didSet {
            if oldValue != nil, oldValue != sizeClass, let oldValue, let sizeClass {
                rebuild(from: oldValue, to: sizeClass)
            }
        }
    }

    func backRoot() {
        detailPath.removeAll()
    }

    func backParent() {
        if !detailPath.isEmpty {
            detailPath.removeLast()
        }
    }

    func selectRootID(rootID: Int) {
        if sizeClass == .regular {
            self.rootID = rootID
            detailPath.removeAll()
        } else {
            self.rootID = rootID
            detailPath.append(.init(level: 1, rootID: rootID))
        }
    }

    func rebuild(from: UserInterfaceSizeClass, to: UserInterfaceSizeClass) {
        guard let rootID else { return }
        if to == .regular {
            if !detailPath.isEmpty {
                detailPath.removeFirst()
            }
        } else {
            detailPath = [.init(level: 1, rootID: rootID)] + detailPath
        }
    }
}

struct DetailInfo: Hashable, Identifiable {
    let id = UUID()
    let level: Int
    let rootID: Int
}

struct AdaptiveNavigatorView: View {
    @StateObject var store = AdaptiveStore()
    @Environment(\.horizontalSizeClass) var sizeClass
    var body: some View {
        VStack {
            if sizeClass == .regular {
                SplitView(store: store)
                    .task {
                        store.sizeClass = sizeClass
                    }
            } else {
                StackView(store: store)
                    .task {
                        store.sizeClass = sizeClass
                    }
            }
            HStack {
                Button("Back Root") { store.backRoot() }
                Button("Back Parent") { store.backParent() }
            }
            .buttonStyle(.bordered)
        }
    }
}

struct SplitView: View {
    @ObservedObject var store: AdaptiveStore
    var body: some View {
        NavigationSplitView {
            SideBarView(store: store)
        } detail: {
            if let rootID = store.rootID {
                NavigationStack(path: $store.detailPath) {
                    DetailInfoView(store: store, info: .init(level: 1, rootID: rootID))
                        .navigationTitle("Root \(rootID), Level:\(store.detailPath.count + 1)")
                        .navigationDestination(for: DetailInfo.self) { info in
                            DetailInfoView(store: store, info: info)
                                .navigationTitle("Root \(info.rootID), Level \(info.level)")
                        }
                }
            } else {
                Text("Empty")
            }
        }
    }
}

struct StackView: View {
    @ObservedObject var store: AdaptiveStore
    var body: some View {
        NavigationStack(path: $store.detailPath) {
            SideBarView(store: store)
                .navigationDestination(for: DetailInfo.self) { info in
                    DetailInfoView(store: store, info: info)
                        .navigationTitle("Root \(info.rootID), Level \(info.level)")
                }
        }
    }
}

struct DetailInfoView: View {
    @ObservedObject var store: AdaptiveStore
    let info: DetailInfo
    var body: some View {
        List {
            Text("RootID:\(info.rootID)")
            Text("Current Level:\(info.level)")
            NavigationLink("Goto Next Level", value: DetailInfo(level: info.level + 1, rootID: info.rootID))
                .foregroundColor(.blue)
        }
    }
}

struct SideBarView: View {
    @ObservedObject var store: AdaptiveStore
    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(0..<30) { rootID in
                    Button {
                        store.selectRootID(rootID: rootID)
                    }
                label: {
                        Text("RootID \(rootID)")
                            .padding(5)
                            .padding(.leading, 10)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .contentShape(Rectangle())
                            .background(store.rootID == rootID ? .cyan : .clear)
                    }
                }
            }
            .buttonStyle(.plain)
        }
        .navigationTitle("Root")
    }
}
