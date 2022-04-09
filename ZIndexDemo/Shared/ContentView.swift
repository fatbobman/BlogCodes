//
//  ContentView.swift
//  Shared
//
//  Created by Yang Xu on 2022/4/9
//  Copyright © 2022 Yang Xu. All rights reserved.
//
//  Follow me on Twitter: @fatbobman
//  My Blog: https://www.fatbobman.com
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            List {
                NavigationLink("zIndex 的作用域", destination: ScopeDemo())
                NavigationLink("不使用 zIndex 导致动画异常", destination: AnimationWithoutZIndex())
                NavigationLink("使用 zIndex 解决动画异常", destination: AnimationWithZIndex())
                NavigationLink("zIndex 不可动画", destination: SwapByZIndex())
                NavigationLink("稳定的 zIndex 值", destination: IndexDemo())
                NavigationLink("不稳定的 zIndex 值", destination: IndexDemo1())
                NavigationLink("使用透明度", destination: SwapByOpacity())
                NavigationLink("使用转场", destination: SwapByTransition())
                NavigationLink("在 VStack 使用 zIndex", destination: ZIndexInVStack())
            }
            .navigationTitle("Demo of zIndex")
        }
        .ignoresSafeArea()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
