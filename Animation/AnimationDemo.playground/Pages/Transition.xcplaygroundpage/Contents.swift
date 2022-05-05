import PlaygroundSupport
import SwiftUI
import Foundation

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
                show.toggle()
            }
        }
        .animation(.easeInOut(duration:3), value: show)
        .frame(width: 300, height: 300)
    }
}

struct SubView:View{
    @StateObject var store = Store()
    var body:some View{
        Text("World")
    }
}

class Store:ObservableObject {
    init(){print("init")}
    deinit {
        print("deinit")
    }
}

PlaygroundPage.current.setLiveView(TransitionDemo())

