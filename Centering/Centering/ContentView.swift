//
//  ContentView.swift
//  Centering
//
//  Created by Yang Xu on 2022/8/29.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            List {
                NavigationLink("明确尺寸", destination: ExplicitSizeDemo())
                NavigationLink("不确定尺寸", destination: UnsureSizeDemo())
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
