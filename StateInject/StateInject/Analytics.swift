//
//  Analytics.swift
//  StateInject
//
//  Created by Yang Xu on 2023/2/22.
//

import Foundation
import SwiftUI

struct AnalyticsView: View {
    @State private var n = 1
    @State private var show = false

    var body: some View {
        let _ = print("Parent View update")
        VStack {
            // Text("n = \(n)") // 注释掉该行后，sheet 中的 n 显示为 1（ 并非预期中的 2 ）
            Button("Set n = 2") {
                n = 2
                show = true
                dump(_n)
                // 即使 Text 被注释掉， dump 信息中的 _wasRead 依然为 true，这是因为 n 已经与
                // sheet 中的视图想关联
            }
            .buttonStyle(.bordered)
        }
        .sheet(isPresented: $show) {
            SheetInitMonitorView(show: $show, n: n)
        }
        .onAppear {
            dump(_n)
            // 当 Text 被注释掉时， dump 信息中的 _wasRead 为 false
            // 表示 n 尚未与当前视图进行关联
        }
    }
}

struct AnalyticsViewPreview: PreviewProvider {
    static var previews: some View {
        AnalyticsView()
    }
}

struct SheetInitMonitorView: View {
    @Binding var show: Bool
    let n: Int
    init(show: Binding<Bool>, n: Int) {
        self._show = show
        self.n = n
        print("sheet view init")
    }

    var body: some View {
        let _ = print("sheet view update")
        VStack {
            Text("n = \(n)")
            Button("Close") {
                show = false
                print("n in fullScreenCover is", n)
            }
            .buttonStyle(.bordered)
        }
    }
}
