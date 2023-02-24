//
//  AlignmentWithoutGeometryReader.swift
//  LayoutInTheSwiftUIWay
//
//  Created by Yang Xu on 2023/2/24.
//

import Foundation
import SwiftUI

struct AlignmentWithoutGeometryReader: View {
    @State var show = false
    var body: some View {
        Color.clear
            .overlay(alignment: .bottom) {
                GreenView()
                    .alignmentGuide(.bottom) {
                        show ? $0[.bottom] : 0
                    }
                    .overlay(alignment: .top) {
                        RedView()
                            .alignmentGuide(.top) { $0[.bottom] }
                    }
                    .animation(.default, value: show)
            }
            .ignoresSafeArea()
            .overlayButton(show: $show)
    }
}

struct AlignmentWithoutGeometryReaderPreview: PreviewProvider {
    static var previews: some View {
        AlignmentWithoutGeometryReader()
    }
}
