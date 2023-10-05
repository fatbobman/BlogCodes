//
//  ExplicitAnimationDemo.swift
//  Transaction
//
//  Created by Yang Xu on 2023/6/25.
//

import SwiftUI

struct ExplicitAnimationDemo: View {
    @State private var isActive = false
    var body: some View {
        VStack {
            Text("Hello World")
                .transactionMonitor("Hello World")
            SubView(isActive: $isActive)
                .transactionMonitor("SubView")
        }
        .animation(.bouncy, value: isActive)
    }
}

struct SubView: View {
    @Binding var isActive: Bool
    var body: some View {
        Rectangle()
            .fill(.cyan)
            .frame(width: 300, height: isActive ? 400 : 200)
            .animation(.bouncy, value: isActive)

        Button("Active") {
            isActive.toggle()
        }
    }
}

#Preview {
    ExplicitAnimationDemo()
}
