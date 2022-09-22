//
//  Demo1.swift
//  Lazy_ForEach_Bug
//
//  Created by Yang Xu on 2022/9/21.
//

import Foundation
import SwiftUI

struct MyState {
    var color: Color = .red
    var show = true
}

struct SubLevel1: View {
    let index: Int
    @State var state = MyState() // 视图中的状态，必须紧靠 ForEach
    var body: some View {
        VStack {
            Rectangle()
                .fill(state.color)
                .frame(maxWidth: .infinity, minHeight: 50)
                .overlay(
                    Text("Index \(index)")
                )
                .onTapGesture {
                    state.color = state.color == .red ? .green : .red
                }

            SubLevel2_WrongVersion()
            SubLevel2_RightVersion(show: $state.show)
        }
    }
}

// 状态无法保留，每次状态都会刷新
struct SubLevel2_WrongVersion: View {
    @State var show = true
    var body: some View {
        VStack {
            Text("lose state").opacity(show ? 1 : 0)
            Button(show ? "Hide" : "Show") { show.toggle() }
        }
    }
}

struct SubLevel2_RightVersion: View {
    @Binding var show: Bool
    var body: some View {
        VStack {
            Text("keep state").opacity(show ? 1 : 0)
            Button(show ? "Hide" : "Show") { show.toggle() }
        }
    }
}

struct Demo1: View {
    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(0..<30, id: \.self) { i in
                    SubLevel1(index: i)
                }
            }
        }
        .navigationTitle("State in level one")
    }
}

// 如果需要持久的状态（ @State、@StateObject ） 不在 ForEach 的第一层子视图中
// 在滚动出屏幕（ 稍远一点距离 ）后再滚动回来，状态会丢失
struct Demo2: View {
    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(0..<30, id: \.self) { i in
                    VStack {   // 第一层视图是 VStack
                        Text("level one is VStack")
                        SubLevel1(index: i)  // 不是最贴近 ForEach 的视图
                    }
                }
            }
        }
        .navigationTitle("State NOT in level one")
    }
}

struct Demo3: View {
    var body: some View {
        List {
            ForEach(0..<30, id: \.self) { i in
                SubLevel1(index: i)
            }
        }
        .navigationTitle("State  in level one")
    }
}

struct Demo4: View {
    var body: some View {
        List {
            ForEach(0..<30, id: \.self) { i in
                VStack {
                    Text("level one is VStack")
                    SubLevel1(index: i)
                }
            }
        }
        .navigationTitle("State NOT in level one")
    }
}

