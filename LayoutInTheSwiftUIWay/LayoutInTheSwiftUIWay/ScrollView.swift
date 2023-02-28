//
//  ScrollView.swift
//  LayoutInTheSwiftUIWay
//
//  Created by Yang Xu on 2023/2/28.
//

import Foundation
import SwiftUI

struct ScrollViewDemo: View {
    @State var show = false
    @State var screenSize: CGSize = .zero
    @State var redViewSize: CGSize = .zero
    var body: some View {
        Color.clear
            .overlay(
                ScrollViewReader { proxy in
                    ScrollView {
                        VStack(spacing: 0) {
                            Color.clear
                                .frame(height: screenSize.height - redViewSize.height)
                            RedView()
                                .sizeInfo($redViewSize)
                                .id("red")
                            GreenView()
                                .id("green")
                        }
                    }
                    .scrollDisabled(true)
                    .onAppear {
                        proxy.scrollTo("red", anchor: .bottom)
                    }
                    .onChange(of: show) { _ in
                        withAnimation {
                            if show {
                                proxy.scrollTo("green", anchor: .bottom)
                            } else {
                                proxy.scrollTo("red", anchor: .bottom)
                            }
                        }
                    }
                }
            )
            .sizeInfo($screenSize)
            .ignoresSafeArea()
            .overlayButton(show: $show)
    }
}

struct ScrollViewDemoPreview: PreviewProvider {
    static var previews: some View {
        ScrollViewDemo()
    }
}
