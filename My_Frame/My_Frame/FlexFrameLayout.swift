//
//  FlexFrameLayout.swift
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

private struct MyFlexFrameLayout: Layout, ViewModifier {
    let minWidth: CGFloat?
    let idealWidth: CGFloat?
    let maxWidth: CGFloat?
    let minHeight: CGFloat?
    let idealHeight: CGFloat?
    let maxHeight: CGFloat?
    let alignment: Alignment

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        guard subviews.count == 2, let content = subviews.last else { fatalError("Can't use MyFlexFrameLayout directly") }

        var resultWidth: CGFloat = 0
        var resultHeight: CGFloat = 0

        let contentWidth = content.sizeThatFits(proposal).width
        if let idealWidth, proposal.width == nil {
            resultWidth = idealWidth // fixedSize(horizontal:true)
        } else if minWidth == nil, maxWidth == nil {
            resultWidth = contentWidth // 没有在横向维度上进行设置
        } else if let minWidth, let maxWidth {
            resultWidth = clamp(min: minWidth, max: maxWidth, source: proposal.width ?? contentWidth)
        } else if let minWidth {
            resultWidth = clamp(min: minWidth, max: maxWidth, source: contentWidth)
        } else if let maxWidth {
            resultWidth = clamp(min: minWidth, max: maxWidth, source: proposal.width ?? contentWidth)
        }

        let contentHeight = content.sizeThatFits(.init(width: proposal.width == nil ? nil : resultWidth, height: proposal.height)).height
        if let idealHeight, proposal.height == nil {
            resultHeight = idealHeight
        } else if minHeight == nil, maxHeight == nil {
            resultHeight = contentHeight
        } else if let minHeight, let maxHeight {
            resultHeight = clamp(min: minHeight, max: maxHeight, source: proposal.height ?? contentHeight)
        } else if let minHeight {
            resultHeight = clamp(min: minHeight, max: maxHeight, source: contentHeight)
        } else if let maxHeight {
            resultHeight = clamp(min: minHeight, max: maxHeight, source: proposal.height ?? contentHeight)
        }

        let size = CGSize(width: resultWidth, height: resultHeight)
        return size
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        guard subviews.count == 2, let background = subviews.first, let content = subviews.last else { fatalError("Can't use MyFlexFrameLayout directly") }
        background.place(at: .zero, anchor: .topLeading, proposal: .init(width: bounds.width, height: bounds.height))
        let backgroundDimensions = background.dimensions(in: .init(width: bounds.width, height: bounds.height))
        let offsetX = backgroundDimensions[alignment.horizontal]
        let offsetY = backgroundDimensions[alignment.vertical]
        let contentDimensions = content.dimensions(in: .init(width: bounds.width, height: bounds.height))
        let leading = offsetX - contentDimensions[alignment.horizontal] + bounds.minX
        let top = offsetY - contentDimensions[alignment.vertical] + bounds.minY
        content.place(at: .init(x: leading, y: top), anchor: .topLeading, proposal: .init(width: bounds.width, height: bounds.height))
    }

    func clamp(min: CGFloat?, max: CGFloat?, source: CGFloat) -> CGFloat {
        var result: CGFloat = source
        if let min {
            result = Swift.max(source, min)
        }
        if let max {
            result = Swift.min(source, max)
        }
        return result
    }

    func body(content: Content) -> some View {
        MyFlexFrameLayout(minWidth: minWidth, idealWidth: idealWidth, maxWidth: maxWidth, minHeight: minHeight, idealHeight: idealHeight, maxHeight: maxHeight, alignment: alignment)() {
            Color.clear
            content
        }
    }
}

public extension View {
    func myFrame(minWidth: CGFloat? = nil, idealWidth: CGFloat? = nil, maxWidth: CGFloat? = nil, minHeight: CGFloat? = nil, idealHeight: CGFloat? = nil, maxHeight: CGFloat? = nil, alignment: Alignment = .center) -> some View {
        func areInNondecreasingOrder(
            _ min: CGFloat?, _ ideal: CGFloat?, _ max: CGFloat?
        ) -> Bool {
            let min = min ?? -.infinity
            let ideal = ideal ?? min
            let max = max ?? ideal
            return min <= ideal && ideal <= max
        }

        if !areInNondecreasingOrder(minWidth, idealWidth, maxWidth)
            || !areInNondecreasingOrder(minHeight, idealHeight, maxHeight) {
            fatalError("Contradictory frame constraints specified.")
        }

        return modifier(MyFlexFrameLayout(minWidth: minWidth, idealWidth: idealWidth, maxWidth: maxWidth, minHeight: minHeight, idealHeight: idealHeight, maxHeight: maxHeight, alignment: alignment))
    }
}

struct MyFlexFrame_Preview:PreviewProvider{
    static var previews: some View{
        HStack{
            let str = "山不在高，有仙则名。水不在深，有龙则灵。斯是陋室，惟吾德馨。苔痕上阶绿，草色入帘青。谈笑有鸿儒，往来无白丁。可以调素琴，阅金经。无丝竹之乱耳，无案牍之劳形。南阳诸葛庐，西蜀子云亭。孔子云：何陋之有？"

            VStack(alignment: .leading) {
                Text(str)
                    .frame(width: 30, alignment: .leading)
                    .fixedSize(horizontal: false, vertical: false)
                    .border(.red)

                Text(str)
                    .myFrame(width: 30, alignment: .leading)
                    .fixedSize(horizontal: false, vertical: false)
                    .border(.red)

            }
            .frame(width:50)
            .border(.red)

            VStack {
                Text(str)
                    .frame(maxWidth: 200,  maxHeight: 200,alignment: .trailingLastTextBaseline)
                    .border(.red)
                    .fixedSize(horizontal: true, vertical: false)

                Text(str)
                    .myFrame(maxWidth: 200, maxHeight: 200,alignment:.trailingLastTextBaseline)
                    .border(.red)
                    .myFixedSize(horizontal: true, vertical: false)
            }
            .frame(width: 300)
        }
    }
}
