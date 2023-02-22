//
//  Solution2.swift
//  StateInject
//
//  Created by Yang Xu on 2023/2/22.
//

import Foundation
import SwiftUI

struct Solution2: View {
    @StateObject var vm = VM()
    @State private var show = false

    var body: some View {
        VStack {
            Button("Set n = 2") {
                vm.n = 2
                show = true
            }
            .buttonStyle(.bordered)
        }
        .sheet(isPresented: $show) {
            VStack {
                Text("n = \(vm.n)")
                Button("Close") {
                    show = false
                    print("n in fullScreenCover is", vm.n)
                }
                .buttonStyle(.bordered)
            }
        }
    }
}

struct Solution2Preview: PreviewProvider {
    static var previews: some View {
        Solution2()
    }
}

class VM: ObservableObject {
    @Published var n = 1
}
