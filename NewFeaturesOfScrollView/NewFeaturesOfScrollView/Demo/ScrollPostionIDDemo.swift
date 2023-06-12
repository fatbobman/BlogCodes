//
//  ScrollPostionIDDemo.swift
//  NewFeaturesOfScrollView
//
//  Created by Yang Xu on 2023/6/12.
//

import SwiftUI

struct ScrollPositionIDDemo: View {
    @State private var show = false
    @State private var position: Position = .trailing
    @State private var items = (0 ..< 500).map {
        Item(n: $0)
    }

    @State private var id: UUID?

    let ending = UUID()
    var body: some View {
        VStack {
            Picker("Position", selection: $position) {
                ForEach(Position.allCases) { p in
                    Text(p.rawValue).tag(p)
                }
            }
            .pickerStyle(.segmented)
            Text(id?.uuidString ?? "").fixedSize().font(.caption2)
            ScrollView(.horizontal) {
                LazyHStack {
                    ForEach(items) { item in
                        CellView(debugInfo: "\(item.n)")
                            .idView(item.n)
                    }
                }
            }
            .scrollPosition(id: $id)
            .scrollTargetLayout()
        }
        .animation(.default, value: id)
        .padding()
        .frame(height: 300)
        .task(id: position) {
            switch position {
            case .leading:
                id = items.first!.id
            case .center:
                id = items[250].id
            case .trailing:
                id = items.last!.id
            }
        }
    }
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

#Preview {
    ScrollPositionIDDemo()
}
