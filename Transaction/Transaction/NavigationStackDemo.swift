//
//  FullScreenCover.swift
//  Transaction
//
//  Created by Yang Xu on 2023/6/26.
//

import SwiftUI

struct NavigationStackDemo: View {
    @State var pathStore = PathStore()
    var body: some View {
        @Bindable var pathStore = pathStore
        NavigationStack(path: $pathStore.path) {
            List {
                Button("Go Link without Animation") {
                    var transaction = Transaction(animation: .none)
                    transaction.disablesAnimations = true
                    withTransaction(transaction) {
                        pathStore.path.append(1)
                    }
                }
                Button("Go Link with Animation") {
                    pathStore.path.append(1)
                }
            }
            .navigationDestination(for: Int.self) {
                ChildView(store: pathStore, n: $0)
            }
        }
    }
}

@Observable
class PathStore {
    var path: [Int] = []
}

struct ChildView: View {
    let store: PathStore
    let n: Int
    @Environment(\.dismiss) var dismiss
    var body: some View {
        List {
            Text("\(n)")
            Button("Dismiss without Animation") {
                var transaction = Transaction(animation: .none)
                transaction.disablesAnimations = true
                withTransaction(transaction) {
                    store.path = []
                }
            }
            Button("Dismiss with Animation") {
                dismiss()
            }
        }
    }
}

#Preview {
    NavigationStackDemo()
}
