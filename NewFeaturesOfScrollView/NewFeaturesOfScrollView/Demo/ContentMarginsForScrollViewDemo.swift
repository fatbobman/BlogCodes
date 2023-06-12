//
//  ContentMarginsForScrollView.swift
//  NewFeaturesOfScrollView
//
//  Created by Yang Xu on 2023/6/12.
//

import SwiftUI

struct ContentMarginsForScrollViewDemo: View {
    @State var text = "Hello world"
    var body: some View {
        VStack {
            ScrollView(.horizontal) {
                HStack {
                    CellView(color: .yellow)
                        .idView("leading")
                    ForEach(0 ..< 15) { i in
                        CellView()
                            .idView(i)
                    }
                    CellView(color: .green)
                        .idView("trailing")
                }
            }
            .border(.blue)

            // Also affected by contentMargins
            TextEditor(text: $text)
                .border(.red)
                .padding()
                .contentMargins(.all, 30, for: .scrollContent)
        }
        // Applies to all scrollable containers within the scope
        .contentMargins(.horizontal, 50, for: .scrollContent)
        .padding(.vertical,20)
    }
}

#Preview {
    ContentMarginsForScrollViewDemo()
}
