import Combine
import Foundation

class T: ObservableObject {
    @MyPublished var name = "hello"
    var cancellable: AnyCancellable?
    var longName = "" {
        didSet {
            print("get new \(longName)")
        }
    }

    init() {
        cancellable = $name.assign(to: \.longName, on: self)
    }
}

@propertyWrapper
public struct MyPublished<Value> {
    public var wrappedValue: Value {
        willSet {
            publisher.subject.send(newValue)
        }
    }

    public var projectedValue: Publisher {
        publisher
    }

    private var publisher: Publisher
    public struct Publisher: Combine.Publisher {
        public typealias Output = Value
        public typealias Failure = Never

        fileprivate var subject: CurrentValueSubject<Value, Never>

        public func receive<S>(subscriber: S) where S: Subscriber, Self.Failure == S.Failure, Self.Output == S.Input {
            subject.subscribe(subscriber)
        }

        fileprivate init(_ output: Output) {
            subject = .init(output)
        }
    }

    public init(wrappedValue: Value) {
        self.wrappedValue = wrappedValue
        publisher = Publisher(wrappedValue)
    }

    public static subscript<OuterSelf: ObservableObject>(
        _enclosingInstance observed: OuterSelf,
        wrapped wrappedKeyPath: ReferenceWritableKeyPath<OuterSelf, Value>,
        storage storageKeyPath: ReferenceWritableKeyPath<OuterSelf, Self>
    ) -> Value {
        get {
            return observed[keyPath: storageKeyPath].wrappedValue
        }
        set {
            if let subject = observed.objectWillChange as? ObservableObjectPublisher {
                subject.send()
                observed[keyPath: storageKeyPath].wrappedValue = newValue
            }
        }
    }
}

// let t = T()
// let a = t.objectWillChange.sink(receiveValue: {
//    print($0, "changed")
// })
// t.name = "dfs"
// print(t.myName)

class TT: ObservableObject {
    @MyPublished var name = "fat"
//    var c:AnyCancellable?
}

let t = T()

let a = t.objectWillChange.sink(receiveValue: {
    print($0, "changed")
})

t.name = "bobman"
t.name = "bobman"

// import SwiftUI
//
// struct TestView:View{
//    @StateObject var t = TT()
//    var body: some View{
//        VStack{
//            let _ = print(t.name)
//            Text(t.name)
//            Button("asd"){
//                t.name = String(Int.random(in: 0...100))
//            }
//        }
//    }
// }
//
// import PlaygroundSupport
//
// PlaygroundPage.current.setLiveView(TestView())
