//
//  ScrollViewDemo.swift
//  ViewThatFits
//
//  Created by Yang Xu on 2023/11/5.
//

import Foundation
import SwiftUI

struct ScrollViewDemo: View {
    @State var step: CGFloat = 3
    var count: Int {
        Int(step)
    }

    var body: some View {
        VStack(alignment:.leading) {
            Text("Count: \(count)")
            Slider(value: $step, in: 3 ... 20, step: 1)

            ViewThatFits {
                content
                ScrollView(.horizontal,showsIndicators: true) {
                    content
                }
            }
        }
        .frame(width: 300)
        .border(.red)
    }

    var content: some View {
        HStack {
            ForEach(0 ..< count, id: \.self) { i in
                Rectangle()
                    .fill(.orange.gradient)
                    .frame(width: 30, height: 30)
                    .overlay(
                        Text(i, format: .number).foregroundStyle(.white)
                    )
            }
        }
    }
}

#Preview {
    ScrollViewDemo()
}
