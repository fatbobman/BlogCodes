import PlaygroundSupport
import SwiftUI

struct AnimationDataMonitorView: View, Animatable {
    static var timestamp = Date()
    var number1: Double
    let prefix: String
    var number2: Double

    var animatableData: AnimatablePair<Double, Double> {
        get { AnimatablePair(number1, number2) }
        set {
            number1 = newValue.first
            number2 = newValue.second
        }
    }

    var body: some View {
        let duration = Date().timeIntervalSince(Self.timestamp).formatted(.number.precision(.fractionLength(2)))
        let currentNumber1 = number1.formatted(.number.precision(.fractionLength(2)))
        let currentNumber2 = number2.formatted(.number.precision(.fractionLength(2)))
        let _ = print(duration, currentNumber1, currentNumber2, separator: ",")

        HStack {
            Text(prefix)
                .foregroundColor(.green)
            Text(number1, format: .number.precision(.fractionLength(3)))
                .foregroundColor(.red)
            Text(number2, format: .number.precision(.fractionLength(3)))
                .foregroundColor(.blue)
        }
    }
}

struct Demo: View {
    @State var startNumber1 = false
    @State var startNumber2 = false
    var body: some View {
        VStack {
            AnimationDataMonitorView(
                number1: startNumber1 ? 1 : 0,
                prefix: "Hi:",
                number2: startNumber2 ? 1 : 0
            )
            Button("Animate") {
                AnimationDataMonitorView.timestamp = Date()
                withAnimation(.linear) {
                    startNumber1.toggle()
                }
                withAnimation(.easeInOut) {
                    startNumber2.toggle()
                }
            }
        }
        .frame(width: 300, height: 300)
    }
}

PlaygroundPage.current.setLiveView(Demo())
