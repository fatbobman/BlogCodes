//
//  layout.swift
//  LayoutInTheSwiftUIWay
//
//  Created by Yang Xu on 2023/2/28.
//

import Foundation
import SwiftUI

struct LayoutPriorityDemo: View {
    @State var show = false
    @State var screenSize: CGSize = .zero
    @State var redViewSize: CGSize = .zero
    var body: some View {
        Color.clear
            .overlay(alignment: show ? .bottom : .top) {
                VStack(spacing: 0) {
                    Spacer()
                        .frame(height: screenSize.height - redViewSize.height)
                        .layoutPriority(show ? 0 : 2)
                    RedView()
                        .sizeInfo($redViewSize)
                    GreenView().layoutPriority(show ? 2 : 0)
                }
                .animation(.default, value: show)
            }
            .sizeInfo($screenSize)
            .ignoresSafeArea()
            .overlayButton(show: $show)
    }
}

struct LayoutPriorityDemoPreview: PreviewProvider {
    static var previews: some View {
        LayoutPriorityDemo()
    }
}
