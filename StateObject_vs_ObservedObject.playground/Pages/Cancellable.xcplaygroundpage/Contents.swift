import Foundation
import Combine

class T1:ObservableObject{
   @Published var id = UUID()

    deinit{
        print("deinit")
    }
}

var t:T1? = T1()

let cancellable = t?.objectWillChange.sink(receiveValue: { _ in
    print("update")
})

dump(cancellable)
t?.objectWillChange.send()

t = nil

t?.objectWillChange.send()
dump(cancellable)
print(cancellable.publisher)

