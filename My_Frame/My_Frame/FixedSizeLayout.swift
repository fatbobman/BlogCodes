//
//  FixedSizeLayout.swift
//  My_Frame
//
//  Created by Yang Xu on 2022/7/6
//  Copyright © 2022 Yang Xu. All rights reserved.
//
//  Follow me on Twitter: @fatbobman
//  My Blog: https://www.fatbobman.com
//

import Foundation
import SwiftUI

private struct MyFixedSizeLayout: Layout, ViewModifier {
    let horizontal: Bool
    let vertical: Bool

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        guard subviews.count == 1, let content = subviews.first else {
            fatalError("Can't use MyFixedSizeLayout directly")
        }
        let width = horizontal ? nil : proposal.width
        let height = vertical ? nil : proposal.height
        let size = content.sizeThatFits(.init(width: width, height: height))
        return size
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        guard subviews.count == 1, let content = subviews.first else {
            fatalError("Can't use MyFixedSizeLayout directly")
        }
        let width = horizontal ? nil : bounds.width
        let height = vertical ? nil : bounds.height

        content.place(at: .init(x: bounds.minX, y: bounds.minY), anchor: .topLeading, proposal: .init(width: width, height: height))
    }

    func body(content: Content) -> some View {
        MyFixedSizeLayout(horizontal: horizontal, vertical: vertical)() {
            content
        }
    }
}

public extension View {
    func myFixedSize(horizontal: Bool, vertical: Bool) -> some View {
        modifier(MyFixedSizeLayout(horizontal: horizontal, vertical: vertical))
    }

    func myFixedSize() -> some View {
        myFixedSize(horizontal: true, vertical: true)
    }
}
