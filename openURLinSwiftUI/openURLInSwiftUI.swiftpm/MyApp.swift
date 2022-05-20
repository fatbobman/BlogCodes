import SwiftUI

@main
struct MyApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
            // 方便测试，无需实际调用
//                .environment(\.openURL, .init(handler: { url in
//                    print(url)
//                    return .discarded
//                }))
        }
    }
}
