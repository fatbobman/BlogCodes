import PlaygroundSupport
import SwiftUI

struct Demo3: View {
    @State var items = (0...3).map { $0 }
    var body: some View {
        VStack {
            Button("In withAnimation") {
                withAnimation(.easeInOut) {
                    items.append(Int.random(in: 0...1000))
                }
            }
            Button("Not in withAnimation") {
                items.appendWithAnimation(Int.random(in: 0...1000), .easeInOut)
            }
            List {
                ForEach(items, id: \.self) { item in
                    Text("\(item)")
                }
            }
            .frame(width: 500, height: 300)
        }
    }
}

extension Array {
    mutating func appendWithAnimation(_ newElement: Element, _ animation: Animation?) {
        withAnimation(animation) {
            append(newElement)
        }
    }
}

PlaygroundPage.current.setLiveView(Demo3())
