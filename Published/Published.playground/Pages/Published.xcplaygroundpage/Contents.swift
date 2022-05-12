import Combine
import Foundation

class Weather: ObservableObject {
    var temperature: Double {
        willSet {
            self.objectWillChange.send()
        }
    }

    init(temperature: Double) {
        self.temperature = temperature
    }
}

let weather = Weather(temperature: 20)
let cancellable = weather.objectWillChange // 订阅 weather 实例
    .sink { _ in
        print("weather will change")
    }

weather.temperature = 25
