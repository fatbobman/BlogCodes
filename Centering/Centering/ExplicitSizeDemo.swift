//
//  ExplicitSizeDemo.swift
//  CenteringAndDividing
//
//  Created by Yang Xu on 2022/8/28.
//

import Foundation
import SwiftUI

struct ExplicitSizeDemo: View {
    var body: some View {
        VStack(spacing: 10) {
            HStack {
                Spacer(minLength: 0)
                hello
                    .sizeInfo()
                Spacer(minLength: 0)
                    .sizeInfo()
            }
            .frame(width: 300, height: 60)
            .background(.blue, ignoresSafeAreaEdges: [])

            HStack(spacing: 0) {
                Color.clear
                    .layoutPriority(0)
                hello
                    .layoutPriority(1)
                Color.clear
                    .layoutPriority(0)
            }
            .frame(width: 300, height: 60)
            .background(Color.cyan)

            ZStack {
                Color.green
                hello
            }
            .frame(width: 300, height: 60)

            ZStack { // 在不明确设置 VStack spacing 的情况下，会出现 VStack spacing 不一致的情况
                Color.gray
                    .frame(width: 300, height: 60)
                hello // 对于文字超过矩形宽度的情况不好处理
            }

            hello
                .frame(width: 300, height: 60, alignment: .center)
                .background(.pink)

            Rectangle()
                .fill(Color.orange)
                .frame(width: 300, height: 60)
                .overlay(hello)

            hello
                .background(
                    Color.cyan.frame(width: 300,height: 60)
                )
                .border(.red)
                .padding(.vertical,100)


            GeometryReader { proxy in
                hello
                    .position(.init(x: proxy.size.width / 2, y: proxy.size.height / 2))
                    .background(Color.brown)
            }
            .frame(width: 300, height: 60)
        }
    }

    var hello: some View {
        Text("Hello world,hello world,hello world")
            .foregroundColor(.black)
            .font(.title)
            .lineLimit(1)
    }
}

struct ExplicitSizeDemo_Previews: PreviewProvider {
    static var previews: some View {
        ExplicitSizeDemo()
    }
}

extension View {
    func sizeInfo() -> some View {
        background(
            GeometryReader { proxy in
//                Spacer(minLength: 0)
                Color.clear
                    .task {
                        print(proxy.size)
                    }
            }
        )
    }
}
