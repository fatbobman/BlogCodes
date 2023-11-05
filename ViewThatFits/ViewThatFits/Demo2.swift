//
//  Demo2.swift
//  ViewThatFits
//
//  Created by Yang Xu on 2023/11/5.
//

import Foundation
import SwiftUI

struct IdealSizeDemo2: View {
    var body: some View {
        Text("GeometryReader has been present since the birth of SwiftUI, playing a crucial role in many scenarios.")
            .fixedSize(horizontal: false, vertical: true)
            .border(.red, width: 2)
            .frame(width: 100, height: 100)
            .border(.blue, width: 2)        
    }
}

#Preview(traits: .landscapeLeft) {
    IdealSizeDemo2()

}
