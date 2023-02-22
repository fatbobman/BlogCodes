//
//  StateTest.swift
//  StateInject
//
//  Created by Yang Xu on 2023/2/22.
//

import Foundation
import SwiftUI

struct StateTest: View {
    @State var n = 10
    var body: some View {
        VStack {
            let _ = print("update")
            Text("Hello \(n)")
            Button("n = n + 1") {
                n += 1
                print(n)
            }
            .buttonStyle(.borderedProminent)

            Button("Dump State"){
                dump(_n) // 查看 State 原始数据，而非 wrappedValue
            }
            .buttonStyle(.borderedProminent)
        }
    }
}

struct StateTestPreview:PreviewProvider {
    static var previews: some View {
        StateTest()
    }
}
