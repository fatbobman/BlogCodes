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
                Spacer(minLength: 0)
            }
            .frame(width: 300, height: 60)
            .background(.blue)

            ZStack {
                Color.green
                hello
            }
            .frame(width: 300, height: 60)

            ZStack { // 在不明确设置 VStack spacing 的情况下，会出现 VStack spacing 不一致的情况
                Color.gray
                    .frame(width: 300, height: 60)
                hello
            }

            hello
                .frame(width: 300, height: 60)
                .background(.pink)

            Rectangle()
                .fill(Color.orange)
                .frame(width: 300, height: 60)
                .overlay(hello)

            GeometryReader { proxy in
                hello
                    .position(.init(x: proxy.size.width / 2, y: proxy.size.height / 2))
                    .background(Color.brown)
            }
            .frame(width: 300, height: 60)
        }
    }

    var hello: some View {
        Text("Hello world")
            .foregroundColor(.white)
            .font(.title)
    }
}

struct ExplicitSizeDemo_Previews: PreviewProvider {
    static var previews: some View {
        ExplicitSizeDemo()
    }
}
