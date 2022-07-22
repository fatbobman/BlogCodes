//
//  Layout_In_SwiftUIApp.swift
//  Layout_In_SwiftUI
//
//  Created by Yang Xu on 2022/7/8.
//

import SwiftUI

@main
struct Layout_In_SwiftUIApp: App {
    var body: some Scene {
        WindowGroup {
//            ContentView()
//            Text("Hello world")
            VStack {
                Text("Hello world")
                    .border(.red)
                    .frame(idealWidth: 100, idealHeight: 100)
                    .fixedSize()
                    .border(.green)
            }
            .border(.green)
        }
    }
}

struct Content1: View {
    var body: some View {
        Text("Hello")
        Text("World")
    }
}

struct Content2: View {
    var body: some View {
        Text("肘子的Swift记事本")
    }
}

// struct App_Preview:PreviewProvider{
//    static var previews: some View{
//        Layout_In_SwiftUIApp()
//    }
// }

