//
//  NameSpace.swift
//  LayoutInTheSwiftUIWay
//
//  Created by Yang Xu on 2023/2/24.
//

import Foundation
import SwiftUI

struct NameSpaceDemo: View {
    @State var show = false
    @Namespace var placeHolder
    @State var greenSize: CGSize = .zero
    var body: some View {
        Color.clear
            // green placeholder
            .overlay(alignment: .bottom) {
                Color.clear // GreenView().opacity(0.01)
                    .frame(height: greenSize.height)
                    .matchedGeometryEffect(id: "bottom", in: placeHolder, anchor: .bottom, isSource: true)
                    .matchedGeometryEffect(id: "top", in: placeHolder, anchor: .top, isSource: true)
            }
            .overlay(
                GreenView()
                    .sizeInfo($greenSize)
                    .matchedGeometryEffect(id: "bottom", in: placeHolder, anchor: show ? .bottom : .top, isSource: false)
            )
            .overlay(
                RedView()
                    .matchedGeometryEffect(id: "top", in: placeHolder, anchor: show ? .bottom : .top, isSource: false)
            )
            .animation(.default, value: show)
            .ignoresSafeArea()
            .overlayButton(show: $show)
    }
}

struct NameSpaceDemoPreview: PreviewProvider {
    static var previews: some View {
        NameSpaceDemo()
    }
}
