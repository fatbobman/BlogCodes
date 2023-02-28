//
//  LayoutProtocol.swift
//  LayoutInTheSwiftUIWay
//
//  Created by Yang Xu on 2023/2/28.
//

import Foundation
import SwiftUI

struct LayoutProtocolDemo: View {
    @State var show = false
    var body: some View {
        Color.clear
            .overlay(
                AlignmentBottomLayout {
                    RedView()
                        .alignmentActive(show ? false : true)
                    GreenView()
                        .alignmentActive(show ? true : false)
                }
                .animation(.default, value: show)
            )
            .ignoresSafeArea()
            .overlayButton(show: $show)
    }
}

struct LayoutProtocolDemoPreview: PreviewProvider {
    static var previews: some View {
        LayoutProtocolDemo()
    }
}

struct ActiveKey: LayoutValueKey {
    static var defaultValue = false
}

extension View {
    func alignmentActive(_ isActive: Bool) -> some View {
        layoutValue(key: ActiveKey.self, value: isActive)
    }
}

struct AlignmentBottomLayout: Layout {
    func makeCache(subviews: Subviews) -> Catch {
        .init()
    }

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout Catch) -> CGSize {
        guard !subviews.isEmpty else { return .zero }
        var height: CGFloat = .zero
        for i in subviews.indices {
            let subview = subviews[i]
            if subview[ActiveKey.self] == true {
                cache.activeIndex = i
            }
            let viewDimension = subview.dimensions(in: proposal)
            height += viewDimension.height
            cache.sizes.append(.init(width: viewDimension.width, height: viewDimension.height))
        }
        return .init(width: proposal.replacingUnspecifiedDimensions().width, height: proposal.replacingUnspecifiedDimensions().height)
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout Catch) {
        guard !subviews.isEmpty else { return }
        var currentY: CGFloat = bounds.height - cache.alignmentHeight + bounds.minY
        for i in subviews.indices {
            let subview = subviews[i]
            subview.place(at: .init(x: bounds.minX, y: currentY), anchor: .topLeading, proposal: proposal)
            currentY += cache.sizes[i].height
        }
    }
}

struct Catch {
    var activeIndex = 0
    var sizes: [CGSize] = []

    var alignmentHeight: CGFloat {
        guard !sizes.isEmpty else { return .zero }
        return sizes[0...activeIndex].map { $0.height }.reduce(0,+)
    }
}
