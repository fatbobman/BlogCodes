//
//  CoverImplicitAnimation.swift
//  Transaction
//
//  Created by Yang Xu on 2023/6/25.
//

import SwiftUI

struct CoverImplicitAnimationDemo: View {
    @State var isActive = false
    var body: some View {
        VStack {
            Rectangle()
                .fill(isActive ? .red : .blue)
                .frame(width: 300, height: 300)
                .animation(.smooth, value: isActive)

            Button("Cover ImplicitAnimation") {
                var transaction = Transaction(animation: .none)
                transaction.disablesAnimations = true
                withTransaction(transaction) {
                    isActive.toggle()
                }
            }
        }
    }
}

#Preview {
    CoverImplicitAnimationDemo()
}
