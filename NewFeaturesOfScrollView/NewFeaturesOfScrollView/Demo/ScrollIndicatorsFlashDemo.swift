//
//  ScrollIndicatorsFlashDemo.swift
//  NewFeaturesOfScrollView
//
//  Created by Yang Xu on 2023/6/12.
//

import SwiftUI

struct ScrollIndicatorsFlashDemo: View {
    @State private var items = (0 ..< 50).map { Item(n: $0) }
    var body: some View {
        VStack {
            Button("Remove First") {
                guard !items.isEmpty else { return }
                items.removeFirst()
            }.buttonStyle(.bordered)
            ScrollView {
                ForEach(items) { item in
                    CellView(width: 100, debugInfo: "\(item.n)")
                        .idView(item.n)
                        .frame(maxWidth:.infinity)
                }
            }
            .animation(.bouncy, value: items.count)
        }
        .padding(.horizontal,10)
        .scrollIndicatorsFlash(onAppear: true)
        .scrollIndicatorsFlash(trigger: items.count)
    }
}

#Preview {
    ScrollIndicatorsFlashDemo()
}
