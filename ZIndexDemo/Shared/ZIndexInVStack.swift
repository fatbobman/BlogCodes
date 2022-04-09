//
//  ZIndexInVStack.swift
//  ZIndexDemo
//
//  Created by Yang Xu on 2022/4/9
//  Copyright © 2022 Yang Xu. All rights reserved.
//
//  Follow me on Twitter: @fatbobman
//  My Blog: https://www.fatbobman.com
//

import SwiftUI

struct ZIndexInVStack: View {
    @State var cells: [Cell] = []
    @State var spacing: CGFloat = -95
    @State var toggle = true
    var body: some View {
        VStack {
            Button("New Cell") {
                newCell()
            }
            .buttonStyle(.bordered)
            Slider(value: $spacing, in: -150...20)
                .padding()
            Toggle("新视图显示在最上面", isOn: $toggle)
                .padding()
                .onChange(of: toggle, perform: { _ in
                    withAnimation {
                        cells.removeAll()
                        spacing = -95
                    }
                })
            VStack(spacing: spacing) {
                Spacer()
                ForEach(cells) { cell in
                    cell
                        .onTapGesture { delCell(id: cell.id) }
                        .zIndex(zIndex(cell.timeStamp))
                }
            }
        }
        .padding()
    }

    func zIndex(_ timeStamp: Date) -> Double {
        if toggle {
            return timeStamp.timeIntervalSince1970
        } else {
            return Date.distantFuture.timeIntervalSince1970 - timeStamp.timeIntervalSince1970
        }
    }

    func newCell() {
        let cell = Cell(
            color: ([Color.orange, .green, .yellow, .blue, .cyan, .indigo, .gray, .pink].randomElement() ?? .red).opacity(Double.random(in: 0.9...0.95)),
            text: String(Int.random(in: 0...1000)),
            timeStamp: Date()
        )
        withAnimation {
            cells.append(cell)
        }
    }

    func delCell(id: UUID) {
        guard let index = cells.firstIndex(where: { $0.id == id }) else { return }
        withAnimation {
            let _ = cells.remove(at: index)
        }
    }
}

struct Cell: View, Identifiable {
    let id = UUID()
    let color: Color
    let text: String
    let timeStamp: Date
    var body: some View {
        RoundedRectangle(cornerRadius: 15)
            .fill(color)
            .frame(width: 300, height: 100)
            .overlay(Text(text))
            .compositingGroup()
            .shadow(radius: 3)
            .transition(.move(edge: .bottom).combined(with: .opacity))
    }
}

struct ZIndexInVStack_Previews: PreviewProvider {
    static var previews: some View {
        ZIndexInVStack()
    }
}
