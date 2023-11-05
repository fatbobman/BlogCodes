//
//  IdealSizeDemo1.swift
//  ViewThatFits
//
//  Created by Yang Xu on 2023/11/5.
//

import Foundation
import SwiftUI

struct IdealSizeDemo1: View {
    var body: some View {
        VStack {
            Text("GeometryReader has been present since the birth of SwiftUI, playing a crucial role in many scenarios.")
                .fixedSize()
            
            Rectangle().fill(.orange)
                .fixedSize()
            
            Circle().fill(.red)
                .fixedSize()
            
            ScrollView(.horizontal) {
                HStack {
                    ForEach(0 ..< 50) { i in
                        Rectangle().fill(.blue).frame(width: 30, height: 30)
                            .overlay(Text("\(i)").foregroundStyle(.white))
                    }
                }
            }
            .fixedSize()
            
            VStack {
                Text("GeometryReader has been present since the birth of SwiftUI, playing a crucial role in many scenarios.")
                Rectangle().fill(.yellow)
            }
            .fixedSize()
        }
    }
}

#Preview {
    IdealSizeDemo1()
}
