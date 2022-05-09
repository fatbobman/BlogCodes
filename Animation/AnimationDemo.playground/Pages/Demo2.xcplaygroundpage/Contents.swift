import PlaygroundSupport
import SwiftUI

struct Demo2: View {
    @State var x: CGFloat = 0
    @State var red = false
    var body: some View {
        VStack {
            Spacer()

            Circle()
                .fill(red ? .red : .blue)
                .frame(width: 30, height: 30)
                .offset(x: x)
                .animation(.easeInOut(duration: 1))
//                .animation(.easeInOut(duration: 1), value: x)
//                .animation(.easeInOut(duration: 1), value: red)
            Spacer()
            Button("Animate") {
                if x == 0 {
                    x = 100
                } else {
                    x = 0
                }
                red.toggle()
            }
        }
        .frame(width: 500, height: 300)
    }
}

PlaygroundPage.current.setLiveView(Demo2())
