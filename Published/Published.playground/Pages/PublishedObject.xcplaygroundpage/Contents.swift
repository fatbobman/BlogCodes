import Combine
import Foundation

// wrappedValue 的内容发生变化时，会调用 enclosingInstance 的 objectWillChange

@propertyWrapper
public struct PublishedObject<Value: ObservableObject> {
    public var wrappedValue: Value

    public init(wrappedValue: Value) {
        self.wrappedValue = wrappedValue
    }

    public static subscript<OuterSelf: ObservableObject>(
        _enclosingInstance observed: OuterSelf,
        wrapped wrappedKeyPath: ReferenceWritableKeyPath<OuterSelf, Value>,
        storage storageKeyPath: ReferenceWritableKeyPath<OuterSelf, Self>
    ) -> Value {
        get {
            if observed[keyPath: storageKeyPath].enclosingInstanceWillChange == nil,
               observed[keyPath: storageKeyPath].cancellable == nil {
                observed[keyPath: storageKeyPath].setup(observed)
            }
            return observed[keyPath: storageKeyPath].wrappedValue
        }
        set {
            if let subject = observed.objectWillChange as? ObservableObjectPublisher {
                subject.send()
            }
            observed[keyPath: storageKeyPath].wrappedValue = newValue
        }
    }

    var cancellable: AnyCancellable?
    var enclosingInstanceWillChange: (() -> Void)?

    private mutating func setup<OuterSelf: ObservableObject>(_ enclosingInstance: OuterSelf) {
        guard let subject = enclosingInstance.objectWillChange as? ObservableObjectPublisher else { return }
        enclosingInstanceWillChange = { [weak subject] in
            subject?.send()
        }
        guard cancellable == nil else { return }
        cancellable = wrappedValue.objectWillChange.sink(receiveValue: { [enclosingInstanceWillChange] _ in
            enclosingInstanceWillChange?()
        })
    }
}

class SubObject: ObservableObject {
    @Published var count = 10
}

class Object: ObservableObject {
    @PublishedObject var obj = SubObject()

    init() {}
}

let object = Object()
let cancellable = object.objectWillChange.sink(receiveValue: { _ in
    print("object will change")
})

object.obj.count = 100

print(object.obj.count)
