//
//  TransactionMonitor.swift
//  Transaction
//
//  Created by Yang Xu on 2023/6/25.
//

import SwiftUI

extension View {
    @ViewBuilder
    func transactionMonitor(_ title: String, _ showAnimation: Bool = true) -> some View {
        transaction {
            print(title, terminator: showAnimation ? ": " : "\n")
            if showAnimation {
                print($0.animation ?? "nil")
            }
        }
    }
}

