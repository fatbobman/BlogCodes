//
//  Question.swift
//  StateInject
//
//  Created by Yang Xu on 2023/2/22.
//

import Foundation
import SwiftUI

// https://stackoverflow.com/questions/73110567/how-state-variables-in-swiftui-are-modified-and-rendered-in-different-views

struct QuestionView: View {
    @State private var n = 1
    @State private var show = false

    var body: some View {
        VStack {
            //Text("n = \(n)") // 注释掉该行后，sheet 中的 n 显示为 1（ 并非预期中的 2 ）
            Button("Set n = 2") {
                n = 2
                show = true
            }
            .buttonStyle(.bordered)
        }
        .sheet(isPresented: $show) {
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
}

struct QuestionViewPreview:PreviewProvider {
    static var previews: some View {
        QuestionView()
    }
}
