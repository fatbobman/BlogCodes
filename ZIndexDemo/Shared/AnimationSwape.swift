//
//  AnimationSwitch.swift
//  ZIndexDemo
//
//  Created by Yang Xu on 2022/4/9
//  Copyright © 2022 Yang Xu. All rights reserved.
//
//  Follow me on Twitter: @fatbobman
//  My Blog: https://www.fatbobman.com
//

import SwiftUI

struct SwapByZIndex: View {
    @State var current: Current = .page1
    var body: some View {
        ZStack {
            SubText(text: Current.page1.rawValue, color: .red)
                .onTapGesture { swap() }
                .zIndex(current == .page1 ? 1 : 0)

            SubText(text: Current.page2.rawValue, color: .green)
                .onTapGesture { swap() }
                .zIndex(current == .page2 ? 1 : 0)

            SubText(text: Current.page3.rawValue, color: .cyan)
                .onTapGesture { swap() }
                .zIndex(current == .page3 ? 1 : 0)
        }
    }

    func swap() {
        withAnimation {
            switch current {
            case .page1:
                current = .page2
            case .page2:
                current = .page3
            case .page3:
                current = .page1
            }
        }
    }
}

struct SwapByOpacity: View {
    @State var current: Current = .page1
    var body: some View {
        ZStack {
            SubText(text: Current.page1.rawValue, color: .red)
                .onTapGesture { swap() }
                .opacity(current == .page1 ? 1 : 0)

            SubText(text: Current.page2.rawValue, color: .green)
                .onTapGesture { swap() }
                .opacity(current == .page2 ? 1 : 0)

            SubText(text: Current.page3.rawValue, color: .cyan)
                .onTapGesture { swap() }
                .opacity(current == .page3 ? 1 : 0)
        }
    }

    func swap() {
        withAnimation {
            switch current {
            case .page1:
                current = .page2
            case .page2:
                current = .page3
            case .page3:
                current = .page1
            }
        }
    }
}

struct SwapByTransition: View {
    @State var current: Current = .page1
    var body: some View {
        VStack {
            switch current {
            case .page1:
                SubText(text: Current.page1.rawValue, color: .red)
                    .onTapGesture { swap() }
            case .page2:
                SubText(text: Current.page2.rawValue, color: .green)
                    .onTapGesture { swap() }
            case .page3:
                SubText(text: Current.page3.rawValue, color: .cyan)
                    .onTapGesture { swap() }
            }
        }
    }

    func swap() {
        withAnimation {
            switch current {
            case .page1:
                current = .page2
            case .page2:
                current = .page3
            case .page3:
                current = .page1
            }
        }
    }
}

enum Current: String, Hashable, Equatable {
    case page1 = "Page 1 tap to Page 2"
    case page2 = "Page 2 tap to Page 3"
    case page3 = "Page 3 tap to Page 1"
}

struct SubText: View {
    let text: String
    let color: Color
    var body: some View {
        ZStack {
            color
            Text(text)
        }
        .ignoresSafeArea()
    }
}




