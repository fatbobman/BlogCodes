//
//  Alignment.swift
//  LayoutInTheSwiftUIWay
//
//  Created by Yang Xu on 2023/2/24.
//

import Foundation
import SwiftUI

struct AlignmentDemo: View {
    @State var show = false
    @State var greenSize: CGSize = .zero
    var body: some View {
        Color.clear
            .overlay(alignment: .bottom) {
                RedView()
                    .alignmentGuide(.bottom) {
                        show ? $0[.bottom] + greenSize.height : $0[.bottom]
                    }
            }
            .overlay(alignment: .bottom) {
                GreenView()
                    .sizeInfo($greenSize)
                    .alignmentGuide(.bottom) {
                        show ? $0[.bottom] : $0[.top]
                    }
            }
            .animation(.default, value: show)
            .ignoresSafeArea()
            .overlayButton(show: $show)
    }
}

struct AlignmentDemoPreview: PreviewProvider {
    static var previews: some View {
        AlignmentDemo()
    }
}
