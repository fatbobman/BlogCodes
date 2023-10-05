//
//  TransactionKey.swift
//  Transaction
//
//  Created by Yang Xu on 2023/6/25.
//

import SwiftUI

enum TapSource {
    case root
    case welcome
    case other

    var animation: Animation? {
        switch self {
        case .root:
            Animation.smooth(duration: 3)
        case .welcome:
            nil
        case .other:
            Animation.linear
        }
    }
}

struct SourceKey: TransactionKey {
    static var defaultValue: TapSource = .root
}

extension Transaction {
    var source: TapSource {
        get { self[SourceKey.self] }
        set { self[SourceKey.self] = newValue }
    }
}

@Observable
class Store {
    var isActive = false
}

struct KeyDemo: View {
    @State private var store = Store()
    var body: some View {
        VStack {
            Rectangle()
                .fill(store.isActive ? .orange : .cyan)
                .frame(width: 300, height: 300)
                .transaction {
                    $0.animation = $0[SourceKey.self].animation
                }

            RootView(store: store)
            WelcomeView(store: store)
        }
    }
}

struct RootView: View {
    let store: Store
    var body: some View {
        Button("From Root") {
            withTransaction(\.source, .root) {
                store.isActive.toggle()
            }
        }
    }
}

struct WelcomeView: View {
    let store: Store
    var body: some View {
        Button("From Welcome") {
            withTransaction(\.source, .welcome) {
                store.isActive.toggle()
            }
        }
    }
}

#Preview{
    KeyDemo()
}
