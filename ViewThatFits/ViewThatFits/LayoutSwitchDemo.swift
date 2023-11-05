//
//  LayoutSwitchDemo.swift
//  ViewThatFits
//
//  Created by Yang Xu on 2023/11/5.
//

import Foundation
import SwiftUI

var logo: some View {
    Rectangle()
        .fill(.orange)
        .frame(idealWidth: 100, maxWidth: 200, idealHeight: 100)
        .overlay(
            Image(systemName: "heart.fill")
                .font(.title)
                .foregroundStyle(.white)
        )
}

var title: some View {
    Text("Hello World")
        .fixedSize()
        .font(.headline).bold()
        .frame(maxWidth: 120)
}

struct LayoutSwitchDemo: View {
    @State var width: CGFloat = 100
    var body: some View {
        VStack {
            ViewThatFits(in: .horizontal) {
                HStack(spacing: 0) {
                    logo
                    title
                }
                VStack(spacing: 0) {
                    logo
                    title
                }
            }
            .frame(maxWidth: width, maxHeight: 130)
            .border(.blue)

            Spacer()
            Slider(value: $width, in: 90 ... 250).padding(50)
        }
    }
}






struct LayoutSwitchDemo1: View {
    @State var width: CGFloat = 100

    var layout: AnyLayout {
        width > 100 ? AnyLayout(HStackLayout(spacing: 0)) : AnyLayout(VStackLayout(spacing: 0))
    }

    var body: some View {
        VStack {
            Button("Layout Switch") {
                width = width == 100 ? 200 : 100
            }

            layout {
                logo
                title
            }
            .animation(.smooth, value: width)
            .border(.blue)
            .frame(width: width)
            .frame(maxHeight: 130)
        }
    }
}

#Preview {
    LayoutSwitchDemo()
}

//#Preview {
//    LayoutSwitchDemo1()
//}
