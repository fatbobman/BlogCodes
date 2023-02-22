//
//  StateInjectApp.swift
//  StateInject
//
//  Created by Yang Xu on 2023/2/22.
//

import SwiftUI

@main
struct StateInjectApp: App {
    var body: some Scene {
        WindowGroup {
            AnalyticsView()
                .buttonStyle(.bordered)
        }
    }
}
