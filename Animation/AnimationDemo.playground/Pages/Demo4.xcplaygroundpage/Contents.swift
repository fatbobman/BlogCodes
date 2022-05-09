import PlaygroundSupport
import SwiftUI

struct Demo4: View {
    @State var x: CGFloat = 0
    @State var y: CGFloat = 0
    var body: some View {
        VStack {
            Spacer()
            Circle()
                .fill(.orange)
                .frame(width: 30, height: 30)
                .offset(x: x, y: y)
            Spacer()
            Button("Animate") {
                withAnimation(.linear) {
                    if x == 0 { x = 100 } else { x = 0 }
                }
                withAnimation(.easeInOut(duration: 1.5)) {
                    if y == 0 { y = 100 } else { y = 0 }
                }
            }
        }
        .frame(width: 500, height: 500)
    }
}

PlaygroundPage.current.setLiveView(Demo4())
