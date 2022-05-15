import Combine
import Foundation
import PlaygroundSupport
import SwiftUI

let container = CoreDataHelper.createNSPersistentContainer()

class Store: ObservableObject {
    @PublishedObject var event = Event(context: container.viewContext)

    init() {
        event.timestamp = Date().addingTimeInterval(-1000)
    }
}

struct DemoView: View {
    @StateObject var store = Store()
    var body: some View {
        VStack {
            Text(store.event.timestamp, format: .dateTime)
            Button("Now") {
                store.event.timestamp = .now
            }
        }
        .frame(width: 300, height: 300)
    }
}

PlaygroundPage.current.setLiveView(DemoView())

