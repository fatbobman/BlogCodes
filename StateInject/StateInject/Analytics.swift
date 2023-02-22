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
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1){
                    dump(_n)
                }
            }
            .buttonStyle(.bordered)
        }
        .sheet(isPresented: $show) {
            SheetInitMonitorView(show: $show, n: n)
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
