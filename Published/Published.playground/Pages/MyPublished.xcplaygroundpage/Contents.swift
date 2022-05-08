import Combine
import Foundation

class T: ObservableObject {
    @MyPublished var name = "hello"
    init() {}
}

let object = T()

let cancellable = object.objectWillChange.sink(receiveValue: {
    print("object will changed")
})

object.name = "fatbobman"
print(object.name)
