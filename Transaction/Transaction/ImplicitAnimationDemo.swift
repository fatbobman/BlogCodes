//
//  ImplicitAnimationDemo.swift
//  Transaction
//
//  Created by Yang Xu on 2023/6/25.
//

import SwiftUI

struct ImplicitAnimationDemo: View {
    @State private var isActive = false
    var body: some View {
        VStack {
            Text("Hello")
                .font(.largeTitle)
                .offset(x: isActive ? 200 : 0)
                .transactionMonitor("inner")
                .animation(.easeIn, value: isActive)
                .transactionMonitor("outer")

            Text("World")
                .transactionMonitor("world")

            Toggle("Active", isOn: $isActive)
                .padding()
        }
        .transactionMonitor("VStack")
        .animation(.linear, value: isActive)
    }
}

#Preview {
    ImplicitAnimationDemo()
}
