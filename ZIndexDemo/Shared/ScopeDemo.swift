//
//  ScopeDemo.swift
//  ZIndexDemo
//
//  Created by Yang Xu on 2022/4/9
//  Copyright © 2022 Yang Xu. All rights reserved.
//
//  Follow me on Twitter: @fatbobman
//  My Blog: https://www.fatbobman.com
//

import SwiftUI

struct ScopeDemo: View {
    var body: some View {
        ZStack {
            // zIndex = 1
            Color.red
                .zIndex(1)

            // zIndex = 0.5
            SubView()
                .zIndex(0.5)

            // zIndex = 0.5, 优先使用最内层的 zIndex 值
            Text("abc")
                .padding()
                .zIndex(0.5)
                .foregroundColor(.green)
                .overlay(
                    Rectangle().fill(.green.opacity(0.5))
                )
                .padding(.top, 100)
                .zIndex(1.3)

            // zIndex = 1.5 ，Group 不是布局容器，有优先使用最内层的 zIndex 值
            Group {
                Text("Hello world")
                    .zIndex(1.5)
            }
            .zIndex(0.5)
        }
        .ignoresSafeArea()
    }
}

struct SubView: View {
    var body: some View {
        ZStack {
            Text("Sub View1")
                .zIndex(3) // zIndex = 3 ，仅在本 ZStack 中比较

            Text("Sub View2") // zIndex = 3.5 ，仅在本 ZStack 中比较
                .zIndex(3.5)
        }
        .padding(.top, 100)
    }
}
