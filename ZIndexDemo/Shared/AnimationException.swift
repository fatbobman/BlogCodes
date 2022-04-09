//
//  AnimationException.swift
//  ZIndexDemo
//
//  Created by Yang Xu on 2022/4/9
//  Copyright © 2022 Yang Xu. All rights reserved.
//
//  Follow me on Twitter: @fatbobman
//  My Blog: https://www.fatbobman.com
//

import Foundation
import SwiftUI

struct AnimationWithoutZIndex: View {
    @State var show = true
    var body: some View {
        ZStack {
            Color.red
            if show {
                Color.yellow
            }
            Button(show ? "Hide" : "Show") {
                withAnimation {
                    show.toggle()
                }
            }
            .buttonStyle(.bordered)
            .padding(.top, 100)
        }
        .ignoresSafeArea()
    }
}

struct AnimationWithZIndex: View {
    @State var show = true
    var body: some View {
        ZStack {
            Color.red
                .zIndex(1)
            if show {
                Color.yellow
                    .zIndex(2)
            }
            Button(show ? "Hide" : "Show") {
                withAnimation {
                    show.toggle()
                }
            }
            .buttonStyle(.bordered)
            .padding(.top, 100)
            .zIndex(3)
        }
        .ignoresSafeArea()
    }
}
