import PlaygroundSupport
import SwiftUI

struct Demo: View {
    @State var animated = false
    @State var position = 0
    var body: some View {
        Text("Hi")
            .offset(x: animated ? 100 : 0)
            .transaction {
                if position < 100 {
                    $0.disablesAnimations = true
                }
            }
            .animation(.spring(), value: animated)
    }
}

PlaygroundPage.current.setLiveView(Demo())




