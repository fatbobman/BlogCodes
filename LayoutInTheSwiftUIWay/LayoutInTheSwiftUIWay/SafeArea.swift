//
//  Position.swift
//  LayoutInTheSwiftUIWay
//
//  Created by Yang Xu on 2023/2/28.
//

import Foundation
import SwiftUI

struct SafeAreaDemo: View {
    @State var show = false
    @State var greenSize: CGSize = .zero
    var body: some View {
        Color.clear
            .overlay(alignment: .bottom) {
                VStack(spacing: 0) {
                    RedView()
                }
                .safeAreaInset(edge: .bottom, spacing: 0) {
                    if show {
                        GreenView()
                            .transition(.move(edge: .bottom))
                    }
                }
                .animation(.default, value: show)
            }
            .ignoresSafeArea()
            .overlayButton(show: $show)
    }
}

struct SafeAreaDemoPreview: PreviewProvider {
    static var previews: some View {
        SafeAreaDemo()
    }
}
