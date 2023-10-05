//
//  IDView.swift
//  NewFeaturesOfScrollView
//
//  Created by Yang Xu on 2023/6/12.
//

import SwiftUI

struct IDView<T>: ViewModifier where T: CustomStringConvertible {
    let item: T
    func body(content: Content) -> some View {
        content
            .overlay(
                Text("\(item.description)")
            )
    }
}

extension View {
    func idView<T>(_ id: T) -> some View where T: CustomStringConvertible {
        modifier(IDView(item: id))
    }
}

#Preview {
    CellView()
}
