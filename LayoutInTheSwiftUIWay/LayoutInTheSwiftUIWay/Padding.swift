//
//  Padding.swift
//  LayoutInTheSwiftUIWay
//
//  Created by Yang Xu on 2023/2/28.
//

import Foundation
import SwiftUI

struct PaddingDemo: View {
    @State var show = false
    @State var greenSize: CGSize = .zero
    var body: some View {
        Color.clear
            .overlay(alignment: .bottom) {
                VStack(spacing: 0) {
                    RedView()
                    GreenView()
                        .sizeInfo($greenSize)
                }
                .padding(.bottom, show ? 0 : -greenSize.height)
                .animation(.default, value: show)
            }
            .ignoresSafeArea()
            .overlayButton(show: $show)
    }
}

struct PaddingDemoPreview: PreviewProvider {
    static var previews: some View {
        PaddingDemo()
    }
}
