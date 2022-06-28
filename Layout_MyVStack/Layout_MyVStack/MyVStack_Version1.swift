//
//  MyVStack_Version1.swift
//  Layout_MyVStack
//
//  Created by Yang Xu on 2022/6/27
//  Copyright © 2022 Yang Xu. All rights reserved.
//
//  Follow me on Twitter: @fatbobman
//  My Blog: https://www.fatbobman.com
//

import Foundation
import SwiftUI

// private struct _MyVStackLayout1: Layout {
//    let spacing: CGFloat
//    let alignment: HorizontalAlignment
//
//    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
//        let subviewSizes = subviewProposalSizes(proposal: proposal, subviews: subviews)
//        let maxWidth: CGFloat = subviewSizes.reduce(0) { currentWidth, subview in
//            max(currentWidth, subview.width)
//        }
//        let spacingHeight: CGFloat = subviews.isEmpty ? 0 : CGFloat(subviews.count - 1) * spacing
//        let height: CGFloat = subviewSizes.reduce(0) { currentHeight, subview in
//            currentHeight + subview.height
//        } + spacingHeight
//
//        return .init(width: maxWidth, height: height)
//    }
//
//    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
//        let (x, anchor) = getPositionXAndAnchor(bounds: bounds)
//        let subviewSizes = subviewProposalSizes(proposal: .init(width: bounds.width, height: bounds.height), subviews: subviews)
//        var y: CGFloat = bounds.minY
//        for index in subviews.indices {
//            subviews[index].place(at: .init(x: x, y: y), anchor: anchor, proposal: .init(width: bounds.width, height: subviewSizes[index].height))
//            y += spacing + subviewSizes[index].height
//        }
//    }
//
//    func subviewProposalSizes(proposal: ProposedViewSize, subviews: Subviews) -> [CGSize] {
//        return subviews.reduce(into: [CGSize]()) { result, subview in
//            result += [subview.sizeThatFits(.init(width: proposal.width, height: nil))]
//        }
//    }
//
//    func getPositionXAndAnchor(bounds: CGRect) -> (x: CGFloat, anchor: UnitPoint) {
//        switch alignment {
//        case .leading:
//            return (bounds.minX, .topLeading)
//        case .center:
//            return (bounds.midX, .top)
//        case .trailing:
//            return (bounds.maxX, .topTrailing)
//        default:
//            return (bounds.midX, .top)
//        }
//    }
//
//    // for Divider()
//    static var layoutProperties: LayoutProperties {
//        var layout = LayoutProperties()
//        layout.stackOrientation = .vertical
//        return layout
//    }
// }

private struct _MyVStackLayout1: Layout {
    let spacing: CGFloat
    let alignment: HorizontalAlignment

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache subviewSizes: inout [CGSize]) -> CGSize {
        subviewSizes = subviewProposalSizes(proposal: proposal, subviews: subviews)
        let maxWidth: CGFloat = subviewSizes.reduce(0) { currentWidth, subview in
            max(currentWidth, subview.width)
        }

        let spacingHeight: CGFloat = subviews.isEmpty ? 0 : CGFloat(subviews.count - 1) * spacing
        let height: CGFloat = subviewSizes.reduce(0) { currentHeight, subview in
            currentHeight + subview.height
        } + spacingHeight

        return .init(width: maxWidth, height: height)
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache subviewSizes: inout [CGSize]) {
        let (x, anchor) = getPositionXAndAnchor(bounds: bounds)
        var y: CGFloat = bounds.minY
        for index in subviews.indices {
            subviews[index].place(at: .init(x: x, y: y), anchor: anchor, proposal: .init(width: bounds.width, height: subviewSizes[index].height))
            y += spacing + subviewSizes[index].height
        }
    }

    func subviewProposalSizes(proposal: ProposedViewSize, subviews: Subviews) -> [CGSize] {
        return subviews.reduce(into: [CGSize]()) { result, subview in
            result += [subview.sizeThatFits(.init(width: proposal.width, height: nil))]
        }
    }

    func getPositionXAndAnchor(bounds: CGRect) -> (x: CGFloat, anchor: UnitPoint) {
        switch alignment {
        case .leading:
            return (bounds.minX, .topLeading)
        case .center:
            return (bounds.midX, .top)
        case .trailing:
            return (bounds.maxX, .topTrailing)
        default:
            return (bounds.midX, .top)
        }
    }

    // for Divider()
    static var layoutProperties: LayoutProperties {
        var layout = LayoutProperties()
        layout.stackOrientation = .vertical
        return layout
    }

    func makeCache(subviews: Subviews) -> [CGSize] {
        []
    }
}

struct MyVStack1<Content>: View where Content: View {
    let spacing: CGFloat
    let alignment: HorizontalAlignment
    let content: Content

    init(alignment: HorizontalAlignment = .center, spacing: CGFloat? = nil, @ViewBuilder content: () -> Content) {
        self.spacing = spacing ?? 0
        self.alignment = alignment
        self.content = content()
    }

    var body: some View {
        _MyVStackLayout1(spacing: spacing, alignment: alignment) {
            content
        }
    }
}

struct MyVStack1_Demo: View {
    @State var alignment: MyAlignment = .center
    @State var spacing: CGFloat = 10
    @State var n = 3

    var body: some View {
        ScrollView {
            Picker("Alignment", selection: $alignment.animation(.easeInOut)) {
                Text("Leading")
                    .tag(MyAlignment.leading)
                Text("Center")
                    .tag(MyAlignment.center)
                Text("Trailing")
                    .tag(MyAlignment.trailing)
            }
            .pickerStyle(.segmented)
            .padding()

            HStack {
                Text(spacing, format: .number.precision(.fractionLength(2)))
                Slider(value: $spacing, in: 0...30)
            }
            .padding()

            MyVStack1(alignment: alignment.alignment, spacing: spacing) {
                let start = Date.now
                Text("山不在高，有仙则名。水不在深，有龙则灵。斯是陋室，惟吾德馨。苔痕上阶绿，草色入帘青。谈笑有鸿儒，往来无白丁。可以调素琴，阅金经。无丝竹之乱耳，无案牍之劳形。南阳诸葛庐，西蜀子云亭。孔子云：何陋之有？")
                Divider()
                Button("序列长度") {
                    withAnimation(.easeInOut) {
                        n = Int.random(in: 1...4)
                    }
                }
                .buttonStyle(.borderedProminent)
                ForEach(0..<n, id: \.self) {
                    Text("ID:\($0)")
                }
                let _ = print("MyVStack:", Date.now.timeIntervalSince(start))
            }
            .sizeInfo()
            .border(.red)

            VStack(alignment: alignment.alignment, spacing: spacing) {
                let start = Date.now
                Text("山不在高，有仙则名。水不在深，有龙则灵。斯是陋室，惟吾德馨。苔痕上阶绿，草色入帘青。谈笑有鸿儒，往来无白丁。可以调素琴，阅金经。无丝竹之乱耳，无案牍之劳形。南阳诸葛庐，西蜀子云亭。孔子云：何陋之有？")
                Divider()
                Button("序列长度") {
                    withAnimation(.easeInOut) {
                        n = Int.random(in: 1...4)
                    }
                }
                .buttonStyle(.borderedProminent)
                ForEach(0..<n, id: \.self) {
                    Text("ID:\($0)")
                }
                let _ = print("VStack:", Date.now.timeIntervalSince(start))
            }
            .sizeInfo()
            .border(.red)
        }
    }
}

struct MyVStack1_Preview: PreviewProvider {
    static var previews: some View {
        MyVStack1_Demo()
    }
}
