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
    ) -> Value where OuterSelf.ObjectWillChangePublisher == ObservableObjectPublisher {
        get {
            if observed[keyPath: storageKeyPath].cancellable == nil {
                observed[keyPath: storageKeyPath].setup(observed)
            }
            return observed[keyPath: storageKeyPath].wrappedValue
        }
        set {
            observed.objectWillChange.send()
            observed[keyPath: storageKeyPath].wrappedValue = newValue
        }
    }

    var cancellable: AnyCancellable?

    private mutating func setup<OuterSelf: ObservableObject>(_ enclosingInstance: OuterSelf) where OuterSelf.ObjectWillChangePublisher == ObservableObjectPublisher {
        cancellable = wrappedValue.objectWillChange.sink(receiveValue: { [weak enclosingInstance] _ in
            (enclosingInstance?.objectWillChange)?.send()
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
