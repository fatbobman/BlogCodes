//
//  TransactionApp.swift
//  Transaction
//
//  Created by Yang Xu on 2023/6/25.
//

import SwiftUI

@main
struct TransactionApp: App {
    var body: some Scene {
        WindowGroup {
            ExplicitAnimationDemo()
                .transactionMonitor("App")
        }
    }
}

