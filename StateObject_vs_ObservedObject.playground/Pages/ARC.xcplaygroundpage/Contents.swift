import Cocoa

class ARCObject{
    let id = UUID()
}

let object1:ARCObject?
let object2:ARCObject?

//print(CFGetRetainCount(object1))

object1 = ARCObject()
object2 = object1

print(CFGetRetainCount(object1))

