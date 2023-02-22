//
//  Solution3.swift
//  StateInject
//
//  Created by Yang Xu on 2023/2/22.
//

import Foundation
import SwiftUI

struct Solution3: View {
    @State private var n = 1
    @State private var show = false

    var body: some View {
        VStack {
            Button("Set n = 2") {
                n = 2
                show = true
            }
            .buttonStyle(.bordered)
        }
        .sheet(isPresented: $show) {
            SheetView(show: $show, n: $n)
        }
    }
}

struct Solution3Preview:PreviewProvider {
    static var previews: some View {
        Solution3()
    }
}

struct SheetView:View {
    @Binding var show:Bool
    @Binding var n:Int
    var body: some View {
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
