import Foundation
import PlaygroundSupport
import SwiftUI

class TestObject: ObservableObject {
    let id = UUID()
    @Published var timestamp = Date.now
}

struct ContentView: View {
    @State var store = TestObject()
    @State var i = 0
    var body: some View {
        VStack {
            Text("\(store.id)")
            SubView(i: 0, text: store.timestamp.timeIntervalSince1970.formatted())
            Button("update date") {
                _store.wrappedValue.timestamp = .now
                i = Int.random(in: 0...1000)
            }
        }
        .onReceive(store.objectWillChange, perform: { _ in
            print("update \(store.timestamp)")
        })
    }
}

struct ColorView: View {
    var body: some View {
        ZStack {
            Rectangle()
                .fill(.purple)
                .onTapGesture {
                    print("Rectangle")
                }
            Color.white.opacity(0)
                .background(
                    GeometryReader{ proxy in
                        Color.clear
                            .task(id:proxy.size){
                                print(proxy.size)
                            }
                    }
                )
        }
        .frame(width: 300, height: 400)
    }
}

PlaygroundPage.current.setLiveView(ColorView())

struct SubView: View {
    let life = Life()
    let i: Int
    let text: String
    var body: some View {
        Text(text)
    }
}

class Life {
    init() {
        print("init")
    }

    deinit {
        print("deinit")
    }
}
