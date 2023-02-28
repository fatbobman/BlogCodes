//
//  LayoutProtocolExample.swift
//  LayoutInTheSwiftUIWay
//
//  Created by Yang Xu on 2023/2/28.
//

import Foundation
import SwiftUI

struct LayoutProtocolExample: View {
    let views = (0..<8).map { $0 }
    @State var index = 0
    var body: some View {
        VStack {
            Picker("", selection: $index) {
                ForEach(views, id: \.self) { i in
                    Text("\(i)").tag(i)
                }
            }
            .pickerStyle(.segmented)
            AlignmentBottomLayout {
                ForEach(views, id: \.self) { i in
                    RoundedRectangle(cornerRadius: 20)
                        .fill(.orange.gradient)
                        .overlay(Text("\(i)").font(.title))
                        .padding([.horizontal, .top], 10)
                        .frame(height: 100)
                        .alignmentActive(index == i ? true : false)
                }
            }
            .animation(.default, value: index)
            .frame(width: 400, height: 400)
            .clipped()
            .border(.blue)
        }
        .padding(20)
    }
}

struct LayoutProtocolExamplePreview: PreviewProvider {
    static var previews: some View {
        LayoutProtocolExample()
    }
}
