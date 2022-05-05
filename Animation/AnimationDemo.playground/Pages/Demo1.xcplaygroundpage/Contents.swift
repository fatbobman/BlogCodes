import PlaygroundSupport
import SwiftUI

struct Demo1: View {
    @State var animated = false
    var body: some View {
        VStack {
            Spacer()
            Text("Hello world")
                .foregroundColor(animated ? .red : .blue)
                .font(animated ? .callout : .title3)
                .offset(x: animated ? 200 : 0)
//                .animation(.easeInOut, value: animated)

            Text("Fat")
                .offset(x: animated ? 200 : 0)

            Spacer()
            Button("animate") {
                animated.toggle()
            }
        }
        .animation(.easeInOut, value: animated)
        .frame(width: 500, height: 300)
    }
}

PlaygroundPage.current.setLiveView(Demo1())


