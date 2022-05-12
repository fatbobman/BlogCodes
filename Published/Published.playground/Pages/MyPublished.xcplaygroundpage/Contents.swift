import Combine
import Foundation

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

        var subject: CurrentValueSubject<Value, Never>

        public func receive<S>(subscriber: S) where S: Subscriber, Self.Failure == S.Failure, Self.Output == S.Input {
            subject.subscribe(subscriber)
        }

        init(_ output: Output) {
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
            observed[keyPath: storageKeyPath].wrappedValue
        }
        set {
            if let subject = observed.objectWillChange as? ObservableObjectPublisher {
                subject.send()
                observed[keyPath: storageKeyPath].wrappedValue = newValue
            }
        }
    }
}

class T: ObservableObject {
    @MyPublished var name = "fat"
    init() {}
}

let object = T()

let c1 = object.objectWillChange.sink(receiveValue: {
    print("object will changed")
})
let c2 = object.$name.sink {
    print("name will get new value \($0)")
}

object.name = "bob"
