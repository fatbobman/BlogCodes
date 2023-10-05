//
//  CoordinatorDemo.swift
//  NewFeaturesOfScrollView
//
//  Created by Yang Xu on 2023/6/12.
//

import SwiftUI

struct CoordinatorDemo: View {
    var body: some View {
        ScrollView {
            ForEach(0 ..< 30) { _ in
                CellView()
                    .overlay(
                        GeometryReader { proxy in
                            if let distanceFromTop = proxy.bounds(of: .scrollView)?.minY {
                                Text(distanceFromTop * -1, format: .number)
                            }
                        }
                    )
            }
        }
        .border(.blue)
        .contentMargins(30, for: .scrollContent)
    }
}

#Preview {
    CoordinatorDemo()
}
