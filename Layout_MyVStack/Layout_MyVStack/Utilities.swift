//
//  Alignment.swift
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

enum MyAlignment: Int, CaseIterable {
    case leading, center, trailing
    var alignment: HorizontalAlignment {
        switch self {
        case .leading:
            return .leading
        case .center:
            return .center
        case .trailing:
            return .trailing
        }
    }
}

extension View {
    func sizeInfo(_ output: Bool = false, label: String = "") -> some View {
        self
            .overlay {
                GeometryReader { proxy in
                    ZStack(alignment: .bottomTrailing) {
                        Color.clear
                        HStack {
                            Text(proxy.size.width, format: .number.precision(.fractionLength(1)))
                            Text("x")
                            Text(proxy.size.height, format: .number.precision(.fractionLength(1)))
                        }
                        .font(.callout)
                    }
                    .task(id: proxy.size) {
                        if output {
                            print("\(label) size is \(proxy.size)")
                        }
                    }
                }
            }
    }
}
