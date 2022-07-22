//
//  ContentView.swift
//  Layout_In_SwiftUI
//
//  Created by Yang Xu on 2022/7/8.
//

import SwiftUI

struct ContentView: View {
//    @State var show = false
//    @State var width: CGFloat = 300
    var body: some View {
        ZStack {
            MockContainer(label: "mock1")() {
                MockContainer(label: "mock2")() {
                    Text("Hello world")
                        .sizeInfo()
                        .border(.green)
                }
                .border(.blue)
            }
            .border(.red)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Text("hello world")
            .frame(width: 34, height: 1)
    }
}

struct ContentView1: View {
    var body: some View {
        VStack {
            Text("Hello world")
        }
    }
}

extension View {
    func sizeInfo() -> some View {
        background(
            GeometryReader { proxy in
                Color.clear
                    .task(id: proxy.size) {
                        print(proxy.frame(in: .global))
                    }
            }
        )
    }
}
