import PlaygroundSupport
import SwiftUI

struct AnimationDataMonitorView: View, Animatable {
    static var timestamp = Date()
    var number: Double
    var animatableData: Double {
        get { number }
        set { number = newValue }
    }

    var body: some View {
        let duration = Date().timeIntervalSince(Self.timestamp).formatted(.number.precision(.fractionLength(2)))
        let currentNumber = number.formatted(.number.precision(.fractionLength(2)))
        let _ = print(duration, currentNumber, separator: ",")

        Text(number, format: .number.precision(.fractionLength(3)))
    }
}

struct Demo: View {
    @State var startAnimation = false
    var body: some View {
        VStack {
            AnimationDataMonitorView(number: startAnimation ? 1 : 0)
                .animation(.linear(duration: 0.3), value: startAnimation)
            Button("Show Data") {
                AnimationDataMonitorView.timestamp = Date()
                startAnimation.toggle()
            }
        }
        .frame(width: 300, height: 300)
    }
}

PlaygroundPage.current.setLiveView(Demo())
