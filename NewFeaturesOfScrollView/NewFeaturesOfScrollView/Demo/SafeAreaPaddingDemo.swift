//
//  SafeAreaPadding.swift
//  NewFeaturesOfScrollView
//
//  Created by Yang Xu on 2023/6/12.
//

import SwiftUI

struct SafeAreaPaddingDemo: View {
    var body: some View {
        HStack {
            ZStack(alignment: .bottom) {
                ScrollView {
                    ForEach(0 ..< 20) { i in
                        CellView(width: nil)
                            .idView(i)
                    }
                }
                .safeAreaPadding(.bottom, 40)

                Text("Bottom View")
                    .font(.title3)
                    .foregroundColor(.indigo)
                    .frame(maxWidth: .infinity, maxHeight: 40)
                    .background(.green.opacity(0.6))
            }

            ScrollView {
                ForEach(0 ..< 20) { i in
                    CellView(width: nil)
                        .idView(i)
                }
            }
            .safeAreaInset(edge: .bottom) {
                Text("Bottom View")
                    .font(.title3)
                    .foregroundColor(.indigo)
                    .frame(maxWidth: .infinity, maxHeight: 40)
                    .background(.green.opacity(0.6))
            }
        }
    }
}

#Preview {
    SafeAreaPaddingDemo()
}
