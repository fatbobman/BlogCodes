import Combine
import Foundation

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
            // only run once
            if observed[keyPath: storageKeyPath].cancellable == nil {
                observed[keyPath: storageKeyPath].setup(observed)
            }
            return observed[keyPath: storageKeyPath].wrappedValue
        }
        set {
            observed.objectWillChange.send() // willSet
            observed[keyPath: storageKeyPath].wrappedValue = newValue
        }
    }

    private var cancellable: AnyCancellable?

    private mutating func setup<OuterSelf: ObservableObject>(_ enclosingInstance: OuterSelf) where OuterSelf.ObjectWillChangePublisher == ObservableObjectPublisher {
        cancellable = wrappedValue.objectWillChange.sink(receiveValue: { [weak enclosingInstance] _ in
            (enclosingInstance?.objectWillChange)?.send()
        })
    }
}
