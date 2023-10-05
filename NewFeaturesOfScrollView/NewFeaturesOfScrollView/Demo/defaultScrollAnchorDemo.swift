//
//  ScrollPositionDemo.swift
//  NewFeaturesOfScrollView
//
//  Created by Yang Xu on 2023/6/12.
//

import SwiftUI

struct defaultScrollAnchorDemo: View {
    @State private var show = false
    @State private var position: Position = .leading
    var body: some View {
        VStack {
            Toggle("Show", isOn: $show)
            Picker("Position", selection: $position) {
                ForEach(Position.allCases) { p in
                    Text(p.rawValue).tag(p)
                }
            }
            .pickerStyle(.segmented)
            if show {
                ScrollView(.horizontal) {
                    LazyHStack {
                        ForEach(0 ..< 10000) { i in
                            CellView(debugInfo: "\(i)")
                                .idView(i)
                        }
                    }
                }
                .defaultScrollAnchor(position.unitPoint)
            }
        }
        .padding()
    }

    enum Position: String, Identifiable, CaseIterable {
        var id: UnitPoint { unitPoint }
        case leading, center, trailing
        var unitPoint: UnitPoint {
            switch self {
            case .leading:
                .leading
            case .center:
                .center
            case .trailing:
                .trailing
            }
        }
    }
}

#Preview {
    defaultScrollAnchorDemo()
}
