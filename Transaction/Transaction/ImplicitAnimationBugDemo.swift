//
//  ImplicitAnimationBugDemo.swift
//  Transaction
//
//  Created by Yang Xu on 2023/6/25.
//

import SwiftUI

struct ImplicitAnimationBugDemo: View {
    @State private var isActive = false
    @State private var scale = false
    var body: some View {
        VStack {
            Rectangle()
                .animation(.smooth) {
                    $0.foregroundStyle(isActive ? Color.red : Color.blue)
                }
                .frame(width: 200, height: 200)
                .transaction {
                    $0.animation = .none
                } body: {
                    $0.scaleEffect(scale ? 1.5 : 1)
                }

            Button("Change") {
                isActive.toggle()
                scale.toggle()
            }
        }
    }
}

#Preview {
    ImplicitAnimationBugDemo()
}
