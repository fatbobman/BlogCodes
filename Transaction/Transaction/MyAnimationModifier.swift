//
//  MyAnimationModifier.swift
//  Transaction
//
//  Created by Yang Xu on 2023/6/25.
//

import SwiftUI

extension View {
    func myAnimation<V>(_ animation: Animation?, value: V) -> some View where V: Equatable {
        modifier(MyAnimationWithValueModifier(animation: animation, value: value))
    }
}

struct MyAnimationWithValueModifier<V>: ViewModifier where V: Equatable {
    @State private var holder: Holder
    private let value: V
    private let animation: Animation?
    init(animation: Animation?, value: V) {
        self.animation = animation
        self.value = value
        _holder = State(wrappedValue: Holder(value: value))
    }

    func body(content: Content) -> some View {
        content
            .transaction { transaction in
                guard value != holder.value else { return }
                holder.value = value
                guard !transaction.disablesAnimations else { return }
                transaction.animation = animation
            }
            .onAppear {} // Fixed the issue where the animation was not playing correctly on its first execution.
    }

    class Holder {
        var value: V
        init(value: V) {
            self.value = value
        }
    }
}
