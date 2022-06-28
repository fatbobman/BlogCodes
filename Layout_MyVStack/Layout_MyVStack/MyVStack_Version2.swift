//
//  MyVStack_Version2.swift
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

private struct _MyVStackLayout2: Layout {
    let spacing: CGFloat
    let alignment: HorizontalAlignment

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache info: inout Info) -> CGSize {
        info.subviews = subviewProposalSizes(proposal: proposal, subviews: subviews)
        info.calculateBounds(spacing: spacing, alignment: alignment)
        return .init(width: info.clipBounds.width, height: info.clipBounds.height)
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache info: inout Info) {
        let boundsOffset = info.clipBounds.minX
        var y:CGFloat = bounds.minY
        for index in subviews.indices {
            let x = info.subviews[index].startX - boundsOffset
            let subInfo = info.subviews[index]
            subviews[index].place(at: .init(x: x, y: y), anchor: .topLeading ,proposal: .init(width: subInfo.proposalSizes.width, height: subInfo.proposalSizes.height))
            y += spacing + subInfo.proposalSizes.height
        }
    }

    func subviewProposalSizes(proposal: ProposedViewSize, subviews: Subviews) -> [SubviewInfo] {
        return subviews.reduce(into: [SubviewInfo]()) { result, subview in
            let viewDimension = subview.dimensions(in: .init(width: proposal.width, height: nil))
            let width = viewDimension.width
            let height = viewDimension.height
            let offset = viewDimension.alignmentGuideOffset(alignment)
            result += [SubviewInfo(proposalSizes: .init(width: width, height: height), guideOffset: offset)]
        }
    }

    // for Divider()
    static var layoutProperties: LayoutProperties {
        var layout = LayoutProperties()
        layout.stackOrientation = .vertical
        return layout
    }

    func makeCache(subviews: Subviews) -> Info {
        .init()
    }

    struct SubviewInfo {
        var proposalSizes: CGSize
        var guideOffset: CGFloat
        var startX: CGFloat = 0
        var endX: CGFloat = 0
    }

    struct Info {
        var subviews: [SubviewInfo] = []
        var originalBounds: CGRect = .zero
        var guideBounds: CGRect = .zero
        var clipBounds: CGRect = .zero
        var proposalSize: CGSize {
            clipBounds.size
        }

        mutating func calculateBounds(spacing: CGFloat, alignment: HorizontalAlignment) {
            calculateOriginalBounds(spacing: spacing)
            calculateGuideBounds(alignment: alignment)
            calculateClipBounds()
        }

        private mutating func calculateOriginalBounds(spacing: CGFloat) {
            let maxWidth: CGFloat = subviews.reduce(0) { currentWidth, info in
                max(currentWidth, info.proposalSizes.width)
            }

            let spacingHeight: CGFloat = subviews.isEmpty ? 0 : CGFloat(subviews.count - 1) * spacing
            let totalHeight: CGFloat = subviews.reduce(0) { height, info in
                height + info.proposalSizes.height
            } + spacingHeight
            originalBounds = .init(x: 0, y: 0, width: maxWidth, height: totalHeight)
        }

        private mutating func calculateGuideBounds(alignment: HorizontalAlignment) {
            var minX: CGFloat = 0
            var maxX: CGFloat = originalBounds.width
            for index in subviews.indices {
                let subInfo = subviews[index]
                let (startX, endX) = placeSubview(boundsWidth: originalBounds.width, viewWidth: subInfo.proposalSizes.width, alignment: alignment, offset: subInfo.guideOffset)
                subviews[index].startX = startX
                subviews[index].endX = endX
                minX = min(startX, minX)
                maxX = max(endX, maxX)
            }
            guideBounds = .init(x: minX, y: 0, width: maxX - minX, height: originalBounds.height)
        }

        private func placeSubview(boundsWidth: CGFloat, viewWidth: CGFloat, alignment: HorizontalAlignment, offset: CGFloat) -> (startX: CGFloat, endX: CGFloat) {
            let startX: CGFloat
            let endX: CGFloat
            switch alignment {
            case .leading:
                startX = 0
                endX = viewWidth
            case .trailing:
                endX = boundsWidth
                startX = boundsWidth - viewWidth
            case .center:
                startX = boundsWidth / 2 - viewWidth / 2
                endX = startX + viewWidth
            default:
                startX = boundsWidth / 2 - viewWidth / 2
                endX = startX + viewWidth
            }
            return (startX - offset, endX - offset)
        }

        private mutating func calculateClipBounds() {
            let minStartX = subviews.reduce(0) { currentStartX, info in
                min(info.startX, currentStartX)
            }
            let maxStartX = subviews.reduce(0) { currentEndX, info in
                max(info.endX, currentEndX)
            }
            clipBounds = .init(x: minStartX, y: 0, width: maxStartX - minStartX, height: originalBounds.height)
        }
    }
}

struct MyVStack2<Content>: View where Content: View {
    let spacing: CGFloat
    let alignment: HorizontalAlignment
    let content: Content

    init(alignment: HorizontalAlignment = .center, spacing: CGFloat? = nil, @ViewBuilder content: () -> Content) {
        self.spacing = spacing ?? 0
        self.alignment = alignment
        self.content = content()
    }

    var body: some View {
        _MyVStackLayout2(spacing: spacing, alignment: alignment) {
            content
        }
    }
}

struct MyVStack2_Demo: View {
    @State var alignment: MyAlignment = .center
    @State var spacing: CGFloat = 10

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

            MyVStack2(alignment: alignment.alignment, spacing: spacing) {
                let start = Date.now
                Text("山不在高，有仙则名。水不在深，有龙则灵。斯是陋室，惟吾德馨。苔痕上阶绿，草色入帘青。谈笑有鸿儒，往来无白丁。可以调素琴，阅金经。无丝竹之乱耳，无案牍之劳形。南阳诸葛庐，西蜀子云亭。孔子云：何陋之有？")
                    .alignmentGuide(.leading, computeValue: { $0[HorizontalAlignment.leading] + 20 })
                    .alignmentGuide(HorizontalAlignment.center, computeValue: { $0[HorizontalAlignment.center] - 45 })
                Button("Click") {}
                    .buttonStyle(.borderedProminent)
                    .alignmentGuide(.leading, computeValue: { $0[HorizontalAlignment.leading] - 30 })
                    .alignmentGuide(HorizontalAlignment.center, computeValue: { $0[HorizontalAlignment.center] - 15 })
                    .alignmentGuide(.trailing, computeValue: { $0[.trailing] - 25 })
                Rectangle()
                    .alignmentGuide(.leading, computeValue: { $0[HorizontalAlignment.leading] + 20 })
                ForEach(0..<3) {
                    Text("ID:\($0)")
                }
                .alignmentGuide(.leading, computeValue: { $0[HorizontalAlignment.leading] + 20 })
                let _ = print("MyVStack:",Date.now.timeIntervalSince(start))
            }
            .sizeInfo()
            .border(.red)

            VStack(alignment: alignment.alignment, spacing: spacing) {
                let start = Date.now
                Text("山不在高，有仙则名。水不在深，有龙则灵。斯是陋室，惟吾德馨。苔痕上阶绿，草色入帘青。谈笑有鸿儒，往来无白丁。可以调素琴，阅金经。无丝竹之乱耳，无案牍之劳形。南阳诸葛庐，西蜀子云亭。孔子云：何陋之有？")
                    .alignmentGuide(.leading, computeValue: { $0[HorizontalAlignment.leading] + 20 })
                    .alignmentGuide(HorizontalAlignment.center, computeValue: { $0[HorizontalAlignment.center] - 45 })
                Button("Click") {}
                    .buttonStyle(.borderedProminent)
                    .alignmentGuide(.leading, computeValue: { $0[HorizontalAlignment.leading] - 30 })
                    .alignmentGuide(HorizontalAlignment.center, computeValue: { $0[HorizontalAlignment.center] - 15 })
                    .alignmentGuide(.trailing, computeValue: { $0[.trailing] - 25 })
                Rectangle()
                    .alignmentGuide(.leading, computeValue: { $0[HorizontalAlignment.leading] + 20 })
                ForEach(0..<3) {
                    Text("ID:\($0)")
                        .alignmentGuide(.leading, computeValue: { $0[HorizontalAlignment.leading] + 20 })
                }
                let _ = print("VStack:",Date.now.timeIntervalSince(start))
            }
            .sizeInfo()
            .border(.red)

            Spacer()
        }
    }
}

struct MyVStack2_Preview: PreviewProvider {
    static var previews: some View {
        MyVStack2_Demo()
    }
}

extension ViewDimensions {
    func alignmentGuideOffset(_ alignment: HorizontalAlignment) -> CGFloat {
        switch alignment {
        case .leading:
            return self[.leading]
        case .center:
            return self[HorizontalAlignment.center] - (width / 2)
        case .trailing:
            return self[.trailing] - width
        default:
            return 0
        }
    }
}
