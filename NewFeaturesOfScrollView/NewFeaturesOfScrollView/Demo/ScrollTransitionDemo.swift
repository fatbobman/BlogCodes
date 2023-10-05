//
//  ScrollTransitionDemo.swift
//  NewFeaturesOfScrollView
//
//  Created by Yang Xu on 2023/6/12.
//

import SwiftUI

struct ScrollTransitionDemo: View {
    @State var clip = false
    var body: some View {
        ZStack(alignment: .bottom) {
            ScrollView(.horizontal) {
                HStack {
                    ForEach(0 ..< 30) { i in
                        CellView()
                            .idView(i)
                            .scrollTransition(.animated,axis: .horizontal) { content, phase in
                                content
                                    .scaleEffect(phase != .identity ? 0.6 : 1)
                                    .opacity(phase != .identity ? 0.3 : 1)
                            }
                    }
                }
            }
            .frame(height: 300)
            .scrollClipDisabled(clip)
            Toggle("Clip", isOn: $clip)
                .padding(16)
        }
    }
}

#Preview {
    ScrollTransitionDemo()
}
