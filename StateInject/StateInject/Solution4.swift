//
//  Solution4.swift
//  StateInject
//
//  Created by Yang Xu on 2023/2/22.
//

import Foundation
import SwiftUI

struct Solution4: View {
    @State private var n = 1
    @State private var show = false

    var body: some View {
        VStack {
            Button("Set n = 2") {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.01 ){
                    n = 2
                }
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

struct Solution4Preview:PreviewProvider {
    static var previews: some View {
        Solution4()
    }
}

