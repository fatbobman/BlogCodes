//
//  FrameLayout.swift
//  My_Frame
//
//  Created by Yang Xu on 2022/7/5
//  Copyright © 2022 Yang Xu. All rights reserved.
//
//  Follow me on Twitter: @fatbobman
//  My Blog: https://www.fatbobman.com
//

import Foundation
import SwiftUI

private struct MyFrameLayout: Layout, ViewModifier {
    let width: CGFloat?
    let height: CGFloat?
    let alignment: Alignment

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        guard subviews.count == 2, let content = subviews.last else { fatalError("Can't use MyFrameLayout directly") }
        var result: CGSize = .zero

        if let width, let height {
            result = .init(width: width, height: height)
        }

        if let width, height == nil {
            let contentHeight = content.sizeThatFits(.init(width: width, height: proposal.height)).height
            result = .init(width: width, height: contentHeight)
        }

        if let height, width == nil {
            let contentWidth = content.sizeThatFits(.init(width: proposal.width, height: height)).width
            result = .init(width: contentWidth, height: height)
        }

        if height == nil, width == nil {
            result = content.sizeThatFits(proposal)
        }

        return result
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        guard subviews.count == 2, let background = subviews.first, let content = subviews.last else { fatalError("Can't use MyFrameLayout directly") }
        background.place(at: .zero, anchor: .topLeading, proposal: .init(width: bounds.width, height: bounds.height))
        let backgroundDimensions = background.dimensions(in: .init(width: bounds.width, height: bounds.height))
        let offsetX = backgroundDimensions[alignment.horizontal]
        let offsetY = backgroundDimensions[alignment.vertical]
        let contentDimensions = content.dimensions(in: .init(width: bounds.width, height: bounds.height))
        let leading = offsetX - contentDimensions[alignment.horizontal] + bounds.minX
        let top = offsetY - contentDimensions[alignment.vertical] + bounds.minY
        content.place(at: .init(x: leading, y: top), anchor: .topLeading, proposal: .init(width: bounds.width, height: bounds.height))
    }

    func body(content: Content) -> some View {
        MyFrameLayout(width: width, height: height, alignment: alignment)() {
            Color.clear
            content
        }
    }
}

public extension View {
    func myFrame(width: CGFloat? = nil, height: CGFloat? = nil, alignment: Alignment = .center) -> some View {
        self
            .modifier(MyFrameLayout(width: width, height: height, alignment: alignment))
    }

    @available(*, deprecated, message: "Please pass one or more parameters.")
    func myFrame() -> some View {
        modifier(MyFrameLayout(width: nil, height: nil, alignment: .center))
    }
}
