//
//  Offset.swift
//  LayoutInTheSwiftUIWay
//
//  Created by Yang Xu on 2023/2/24.
//

import Foundation
import SwiftUI

struct OffsetDemo: View {
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
                .offset(y: show ? 0 : greenSize.height)
                .animation(.default, value: show)
            }
            .ignoresSafeArea()
            .overlayButton(show: $show)
    }
}

struct OffsetDemoPreview: PreviewProvider {
    static var previews: some View {
        OffsetDemo()
    }
}
