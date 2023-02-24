//
//  Transition.swift
//  LayoutInTheSwiftUIWay
//
//  Created by Yang Xu on 2023/2/24.
//

import Foundation
import SwiftUI

struct TransitionDemo:View {
    @State var show = false
    var body: some View {
        Color.clear
            .overlay(alignment:.bottom){
                VStack(spacing:0) {
                    RedView()
                    if show {
                        GreenView()
                            .transition(.move(edge: .bottom))
                    }
                }
                .animation(.default, value: show)
            }
            .ignoresSafeArea()
            .overlayButton(show: $show) // 不能使用显式动画
    }
}

struct TransitionDemoPreview:PreviewProvider {
    static var previews: some View {
        TransitionDemo()
    }
}
