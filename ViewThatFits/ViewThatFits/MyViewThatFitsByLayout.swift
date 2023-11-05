//
//  MyViewThatFitsByLayout.swift
//  ViewThatFits
//
//  Created by Yang Xu on 2023/11/5.
//

import Foundation
import SwiftUI

struct MyViewThatFitsByLayoutDemo: View {
    @State var width: CGFloat = 100
    var body: some View {
        VStack {
            Slider(value: $width, in: 30 ... 300)
                .padding()
            ViewThatFits {
                Text("Fatbobman's Swift Weekly")
                Text("Fatbobman's Weekly")
                Text("Fat's Weekly")
                Text("Weekly")
                    .fixedSize()
            }
            .frame(width: width)
            .border(.red)

            MyViewThatFitsByLayout {
                Text("Fatbobman's Swift Weekly")
                Text("Fatbobman's Weekly")
                Text("Fat's Weekly")
                Text("Weekly")
                    .fixedSize()
            }
            .frame(width: width)
            .border(.red)
        }
    }
}

#Preview{
    MyViewThatFitsByLayoutDemo()
}


struct _MyViewThatFitsLayout: Layout {
    let axis: Axis.Set
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout Int?) -> CGSize {
        // No subviews, return zero
        guard !subviews.isEmpty else { return .zero }
        // One subview, returns the required size of the subview
        guard subviews.count > 1 else {
            cache = subviews.endIndex - 1
            return subviews[subviews.endIndex - 1].sizeThatFits(proposal)
        }
        // From the first to the penultimate subview, obtain its ideal size in the limited axis one by one for judgment.
        for i in 0..<subviews.count - 1 {
            let size = subviews[i].dimensions(in: .unspecified)
            switch axis {
            case [.horizontal, .vertical]:
                if size.width <= proposal.replacingUnspecifiedDimensions().width && size.height <= proposal.replacingUnspecifiedDimensions().height {
                    cache = i
                    // If the judgment conditions are met, return the required size of the subview (ask with the normal recommended size)
                    return subviews[i].sizeThatFits(proposal)
                }
            case .horizontal:
                if size.width <= proposal.replacingUnspecifiedDimensions().width {
                    cache = i
                    return subviews[i].sizeThatFits(proposal)
                }
            case .vertical:
                if size.height <= proposal.replacingUnspecifiedDimensions().height {
                    cache = i
                    return subviews[i].sizeThatFits(proposal)
                }
            default:
                break
            }
        }
        // If none of the above are satisfied, use the last subview
        cache = subviews.endIndex - 1
        return subviews[subviews.endIndex - 1].sizeThatFits(proposal)
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout Int?) {
        for i in subviews.indices {
            if let cache, i == cache {
                subviews[i].place(at: bounds.origin, anchor: .topLeading, proposal: proposal)
            } else {
                // Place the subviews that do not need to be displayed in a position that cannot be displayed
                subviews[i].place(at: .init(x: 100_000, y: 100_000), anchor: .topLeading, proposal: .zero)
            }
        }
    }

    func makeCache(subviews _: Subviews) -> Int? {
        nil
    }
}

public struct MyViewThatFitsByLayout<Content>: View where Content: View {
    let axis: Axis.Set
    let content: Content

    public init(axis: Axis.Set = [.horizontal, .vertical], @ViewBuilder content: @escaping () -> Content) {
        self.axis = axis
        self.content = content()
    }

    public var body: some View {
        _MyViewThatFitsLayout(axis: axis) {
            content
        }
    }
}


