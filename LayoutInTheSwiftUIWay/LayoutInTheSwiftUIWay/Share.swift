//
//  Share.swift
//  LayoutInTheSwiftUIWay
//
//  Created by Yang Xu on 2023/2/24.
//

import Foundation
import SwiftUI

struct RedView: View {
    var body: some View {
        Rectangle()
            .fill(.red)
            .frame(height: 600)
    }
}

struct GreenView: View {
    var body: some View {
        Rectangle()
            .fill(.green)
            .frame(height: 600)
    }
}

struct OverlayButton: View {
    @Binding var show: Bool
    var body: some View {
        Button(show ? "Hide" : "Show") {
            show.toggle()
        }
        .buttonStyle(.borderedProminent)
    }
}

extension View {
    func overlayButton(show: Binding<Bool>) -> some View {
        self
            .overlay(alignment: .bottom) {
                OverlayButton(show: show)
            }
    }
}

struct SizeInfoModifier: ViewModifier {
    @Binding var size: CGSize
    func body(content: Content) -> some View {
        content
            .background(
                GeometryReader { proxy in
                    Color.clear
                        .task(id: proxy.size) {
                            size = proxy.size
                        }
                }
            )
    }
}

extension View {
    func sizeInfo(_ size: Binding<CGSize>) -> some View {
        self
            .modifier(SizeInfoModifier(size: size))
    }
}
