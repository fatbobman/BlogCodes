//
//  IndexDemo.swift
//  ZIndexDemo
//
//  Created by Yang Xu on 2022/4/9
//  Copyright © 2022 Yang Xu. All rights reserved.
//
//  Follow me on Twitter: @fatbobman
//  My Blog: https://www.fatbobman.com
//

import SwiftUI

struct IndexDemo: View {
    @State var backgrounds = (0...10).map { i in BackgroundWithIndex(index: Double(i)) }
    var body: some View {
        ZStack {
            ForEach(backgrounds) { background in
                background.color
                    .offset(background.offset)
                    .frame(width: 200, height: 200)
                    .onTapGesture {
                        withAnimation {
                            if let index = backgrounds.firstIndex(where: { $0.id == background.id }) {
                                backgrounds.remove(at: index)
                            }
                        }
                    }
                    .zIndex(background.index)
            }
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
        .ignoresSafeArea()
    }
}

struct BackgroundWithIndex: Identifiable {
    let id = UUID()
    let index: Double
    let color: Color = {
        [Color.orange, .green, .yellow, .blue, .cyan, .indigo, .gray, .pink].randomElement() ?? .red.opacity(Double.random(in: 0.8...0.95))
    }()

    let offset: CGSize = .init(width: CGFloat.random(in: -200...200), height: CGFloat.random(in: -200...200))
}


struct IndexDemo1: View {
    @State var backgrounds = (0...10).map { _ in BackgroundWithoutIndex() }
    var body: some View {
        ZStack {
            ForEach(Array(backgrounds.enumerated()), id: \.element.id) { item in
                let background = item.element
                background.color
                    .offset(background.offset)
                    .frame(width: 200, height: 200)
                    .onTapGesture {
                        withAnimation {
                            if let index = backgrounds.firstIndex(where: { $0.id == background.id }) {
                                backgrounds.remove(at: index)
                            }
                        }
                    }
                    .zIndex(Double(item.offset))
            }
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
        .ignoresSafeArea()
    }
}

struct BackgroundWithoutIndex: Identifiable {
    let id = UUID()
    let color: Color = {
        [Color.orange, .green, .yellow, .blue, .cyan, .indigo, .gray, .pink].randomElement() ?? .red.opacity(Double.random(in: 0.8...0.95))
    }()

    let offset: CGSize = .init(width: CGFloat.random(in: -200...200), height: CGFloat.random(in: -200...200))
}
