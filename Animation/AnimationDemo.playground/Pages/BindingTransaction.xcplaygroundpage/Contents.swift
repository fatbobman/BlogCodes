import PlaygroundSupport
import SwiftUI

struct Demo: View {
    @State var animated = false
    let animation: Animation?

    var animatedBinding: Binding<Bool> {
        let transaction = Transaction(animation: animation)
        return $animated.transaction(transaction)
    }

    var body: some View {
        VStack {
            Text("Hi")
                .offset(x: animated ? 100 : 0)

            Toggle("Animated", isOn: animatedBinding)
        }
        .frame(width: 400, height: 500)
    }
}

PlaygroundPage.current.setLiveView(Demo(animation: .easeInOut))
