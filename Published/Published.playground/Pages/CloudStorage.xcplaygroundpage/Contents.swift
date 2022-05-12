import Foundation
import PlaygroundSupport
import SwiftUI

class Settings: ObservableObject {
    @AppStorage("name") var name = "fat"
    @AppStorage("age") var age = 5
    @CloudStorage("readyForAction") var readyForAction = false
    @CloudStorage("speed") var speed: Double = 0
}

struct DemoView: View {
    @StateObject var settings = Settings()
    var body: some View {
        Form {
            TextField("Name", text: $settings.name)
            TextField("Age", value: $settings.age, format: .number)
            Toggle("Ready", isOn: $settings.readyForAction)
                .toggleStyle(.switch)
            TextField("Speed", value: $settings.speed, format: .number)
        }
        .frame(width: 400, height: 400)
    }
}

PlaygroundPage.current.setLiveView(DemoView())
