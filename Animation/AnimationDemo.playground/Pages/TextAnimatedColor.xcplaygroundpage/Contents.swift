import PlaygroundSupport
import SwiftUI

extension View {
    func animatableForeground(_ color: Color) -> some View {
        self
            .overlay(Rectangle().fill(color))
            .mask {
                self
                    .blendMode(.overlay)
            }
    }
}

struct Demo: View {
    @State var animated = false
    var body: some View {
        VStack {
            Button("Animate") {
                animated.toggle()
            }
            Spacer()
            Text("Hello world")
                .font(.title)
                .animatableForeground(animated ? .green : .orange)
                .animation(.easeInOut(duration: 1), value: animated)
        }
        .frame(height: 300)
    }
}

PlaygroundPage.current.setLiveView(Demo())
