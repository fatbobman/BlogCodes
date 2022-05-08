import Combine
import Foundation

// wrappedValue 的内容发生变化时，会调用 enclosingInstance 的 objectWillChange

@propertyWrapper
public struct PublishedObject<Value: ObservableObject> {
    public var wrappedValue: Value

    public init(wrappedValue: Value) {
        self.wrappedValue = wrappedValue
        cancellable = wrappedValue.objectWillChange.sink(receiveValue: { [holder] _ in
            holder.notificationSender?()
        })
    }

    public static subscript<OuterSelf: ObservableObject>(
        _enclosingInstance observed: OuterSelf,
        wrapped wrappedKeyPath: ReferenceWritableKeyPath<OuterSelf, Value>,
        storage storageKeyPath: ReferenceWritableKeyPath<OuterSelf, Self>
    ) -> Value {
        get {
            print("get")
            observed[keyPath: storageKeyPath].setSender(observed)
            return observed[keyPath: storageKeyPath].wrappedValue
        }
        set {
            print("set") // replace whole wrappedValue
            if let subject = observed.objectWillChange as? ObservableObjectPublisher
            {
                subject.send()
            }
            observed[keyPath: storageKeyPath].wrappedValue = newValue
        }
    }

    class Holder{
        var notificationSender: (() -> Void)?
        init(){}
    }

    private var cancellable:AnyCancellable?
    let holder = Holder()

    private mutating func setSender<OuterSelf:ObservableObject>(_ enclosingInstance:OuterSelf){
        guard holder.notificationSender == nil,let subject = enclosingInstance.objectWillChange as? ObservableObjectPublisher else {return}
        holder.notificationSender = { [weak subject] in
           print("inner change")
           subject?.send()
        }
    }
}

class Obj: ObservableObject {
    @Published var age = 10
}

class Demo: ObservableObject {
    @Published var name = "fat"
    @PublishedObject var obj = Obj()

    var cancellable: AnyCancellable?
    init() {
        cancellable = obj.objectWillChange.sink(receiveValue: {
            print("changed", $0)
            print(self.obj.age)
        })
    }
}


let d = Demo()
let a = d.objectWillChange.sink(receiveValue: { _ in
    print("d changed")
})


d.obj.age = 100
d.obj.age = 200

print(d.obj.age)
