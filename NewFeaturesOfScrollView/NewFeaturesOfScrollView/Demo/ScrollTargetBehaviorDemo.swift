//
//  ScrollTargetBehaviorDemo.swift
//  NewFeaturesOfScrollView
//
//  Created by Yang Xu on 2023/6/12.
//

import SwiftUI

struct ScrollTargetBehaviorDemo: View {
    @State var items = (0 ..< 100).map { Item(n: $0) }
    @State private var isEnabled = true
    var body: some View {
        VStack {
            Toggle("Layout enable", isOn: $isEnabled).padding()
            ScrollView {
                LazyVStack {
                    ForEach(items) { item in
                        CellView(width: 200, height: 140)
                            .idView(item.n)
                    }
                }
                .scrollTargetLayout(isEnabled: isEnabled)
            }
            .border(.red, width: 2)
        }
        .scrollTargetBehavior(.viewAligned)
        .frame(height: 300)
        .padding()
    }
}

#Preview {
    ScrollTargetBehaviorDemo()
}

