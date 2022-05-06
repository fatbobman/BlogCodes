import PlaygroundSupport
import SwiftUI

struct Demo: View {
    @GestureState var position: CGPoint = .zero
    var body: some View {
        VStack {
            Circle()
                .fill(.orange)
                .frame(width: 30, height: 50)
                .offset(x: position.x, y: position.y)
                .transaction {
                    if $0.isContinuous {
                        $0.animation = nil
                    } else {
                        $0.animation = .easeInOut(duration: 1)
                    }
                }
                .gesture(
                    DragGesture()
                        .updating($position, body: { current, state, transaction in
                            state = .init(x: current.translation.width, y: current.translation.height)
                            transaction.isContinuous = true
                        })
                )
        }
        .frame(width: 400, height: 500)
    }
}

PlaygroundPage.current.setLiveView(Demo())
