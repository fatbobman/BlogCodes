import Combine
import Foundation
import PlaygroundSupport
import SwiftUI

let container = CoreDataHelper.createNSPersistentContainer()

class Test: ObservableObject {
    @PublishedObject var event = Event(context: container.viewContext)
}

let test = Test()
let c1 = test.objectWillChange.sink { print("object will change") }

test.event.timestamp = Date()
