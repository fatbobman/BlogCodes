import Foundation
import PlaygroundSupport
import SwiftUI

struct TransitionDemo: View {
    @State var show = true
    var body: some View {
        VStack {
            Spacer()
            Text("Hello")
            if show {
                SubView()
                    .transition(.slide)
            }
            Spacer()
            Button(show ? "Hide" : "Show") {
                // 当时在运动结束前再次点击，可中断动画，且保留原始视图
                show.toggle()
            }
        }
        .animation(.easeInOut(duration: 3), value: show)
        .frame(width: 300, height: 300)
    }
}

struct SubView: View {
    @StateObject var store = Store()
    var body: some View {
        Text("World")
    }
}

class Store: ObservableObject {
    init() { print("init") }
    deinit {
        print("deinit")
    }
}

PlaygroundPage.current.setLiveView(TransitionDemo())
