//
//  ScrollClipDisableDemo.swift
//  NewFeaturesOfScrollView
//
//  Created by Yang Xu on 2023/6/12.
//

import SwiftUI

struct ScrollClipDisableDemo: View {
    @State private var disable = true
    var body: some View {
        VStack {
            Toggle("Clip Disable", isOn: $disable)
                .padding(20)
            ScrollView {
                ForEach(0 ..< 10) { i in
                    CellView()
                        .idView(i)
                        .shadow(color: .black, radius: 50)
                }
            }
        }
        .scrollClipDisabled(disable)
    }
}

#Preview {
    ScrollClipDisableDemo()
}
