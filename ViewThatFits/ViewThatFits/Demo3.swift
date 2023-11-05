//
//  Demo3.swift
//  ViewThatFits
//
//  Created by Yang Xu on 2023/11/5.
//

import Foundation
import SwiftUI

struct IdealSizeDemo3: View {
    var body: some View {
        HStack {
            // ViewThatFits result
            ViewThatFits(in: .vertical) {
                Text("1: GeometryReader has been present since the birth of SwiftUI, playing a crucial role in many scenarios.")
                Text("2: In addition, some views believe that:")
            }
            .border(.blue)
            .frame(width: 200, height: 100, alignment: .top)
            .border(.red)

            // Text1's ideal size ,only vetical fixed
            Text("1: GeometryReader has been present since the birth of SwiftUI, playing a crucial role in many scenarios.")
                .fixedSize(horizontal: false, vertical: true)
                .border(.blue)
                .frame(width: 200, height: 100, alignment: .top)
                .border(.red)
            
            // Text2's ideal size ,only vetical fixed
            Text("2: In addition, some views believe that:")
                .fixedSize(horizontal: false, vertical: true)
                .border(.blue)
                .frame(width: 200, height: 100, alignment: .top)
                .border(.red)
        }
    }
}

#Preview(traits: .landscapeLeft) {
    IdealSizeDemo3()
}

