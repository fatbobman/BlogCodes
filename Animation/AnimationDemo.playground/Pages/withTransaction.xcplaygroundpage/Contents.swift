import PlaygroundSupport
import SwiftUI

struct Demo: View {
    @State var position: CGFloat = 40
    var body: some View {
        VStack {
            Text("Hi")
                .offset(x: position, y: position)
                .animation(.easeInOut, value: position)

            Slider(value: $position, in: 0...150)
            Button("Animate") {
                var transaction = Transaction()
                if position < 100 { transaction.disablesAnimations = true }
                withTransaction(transaction) {
                    position = 0
                }
            }
        }
        .frame(width: 400, height: 500)
    }
}

PlaygroundPage.current.setLiveView(Demo())
