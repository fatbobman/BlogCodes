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

        content.place(at: .init(x: bounds.minX, y: bounds.minY), anchor: .topLeading, proposal: .init(width: bounds.width, height: bounds.height))
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

struct MyFixedSize_Preview:PreviewProvider{
    static var previews: some View{
        VStack(spacing: 20) {
            let str = "山不在高，有仙则名。水不在深，有龙则灵。斯是陋室，惟吾德馨。苔痕上阶绿，草色入帘青。谈笑有鸿儒，往来无白丁。可以调素琴，阅金经。无丝竹之乱耳，无案牍之劳形。南阳诸葛庐，西蜀子云亭。孔子云：何陋之有？"

            Rectangle()
                .myFixedSize()

            Text(str)
                .myFixedSize(horizontal: false, vertical: true)

            Text(str)
                .frame(maxWidth: 100)
                .myFixedSize()

            Text(str)
                .frame(minWidth: 50, idealWidth: 120, maxWidth: 150)
                .myFixedSize()

            Text(str)
                .frame(maxHeight: 50)
                .myFixedSize(horizontal: false, vertical: true)
        }
        .frame(width: 200, height: 30)
    }
}
