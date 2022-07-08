//
//  ContentView.swift
//  My_Frame
//
//  Created by Yang Xu on 2022/7/5
//  Copyright © 2022 Yang Xu. All rights reserved.
//
//  Follow me on Twitter: @fatbobman
//  My Blog: https://www.fatbobman.com
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        Text("MyFrame Demo")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

extension View {
    func printSizeInfo(_ label: String = "") -> some View {
        background(
            GeometryReader { proxy in
                Color.clear
                    .task(id: proxy.size) {
                        print(label, proxy.size)
                    }
            }
        )
    }
}
