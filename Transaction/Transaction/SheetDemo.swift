//
//  SheetDemo.swift
//  Transaction
//
//  Created by Yang Xu on 2023/6/26.
//

import SwiftUI

struct SheetDemo: View {
    @State private var isActive = false
    var body: some View {
        List {
            Button("Pop Sheet without Animation") {
                var transaction = Transaction(animation: .none)
                transaction.disablesAnimations = true
                withTransaction(transaction) {
                    isActive.toggle()
                }
            }
            Button("Pop Sheet with Animation") {
                isActive.toggle()
            }
        }
        .sheet(isPresented: $isActive) {
            VStack {
                Button("Dismiss without Animation") {
                    var transaction = Transaction(animation: .none)
                    transaction.disablesAnimations = true
                    withTransaction(transaction) {
                        isActive.toggle()
                    }
                }
                Button("Dismiss with Animation") {
                    isActive.toggle()
                }
            }
            .buttonStyle(.borderedProminent)
        }
    }
}

#Preview {
    SheetDemo()
}
