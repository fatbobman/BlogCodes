//
//  UnsureSizeDemo.swift
//  CenteringAndDividing
//
//  Created by Yang Xu on 2022/8/28.
//

import Foundation
import SwiftUI

struct UnsureSizeDemo: View {
    var body: some View {
        List {
            Group {
                HStack {
                    Spacer(minLength: 0)
                    hello
                    Spacer(minLength: 0)
                }
                .frame(maxHeight: .infinity)
                .background(.blue)

                HStack(spacing: 0) {
                    Color.clear
                        .layoutPriority(0)
                    hello
                        .layoutPriority(1)
                    Color.clear
                        .layoutPriority(0)
                }
                .background(Color.cyan)

                ZStack {
                    Color.green
                    hello
                }

                hello
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(.pink)

                Rectangle()
                    .fill(Color.orange)
                    .overlay(hello)

                GeometryReader { proxy in
                    hello
                        .position(.init(x: proxy.size.width / 2, y: proxy.size.height / 2))
                        .background(Color.brown)
                }
            }
            .listRowInsets(.init(top: 10, leading: 45, bottom: 10, trailing: 45))
        }
        .listStyle(.plain)
        .environment(\.defaultMinListRowHeight, 80)
    }

    var hello: some View {
        Text("Hello world")
            .foregroundColor(.white)
            .font(.title)
    }
}

struct UnsureSizeDemo_Previews: PreviewProvider {
    static var previews: some View {
        UnsureSizeDemo()
    }
}
