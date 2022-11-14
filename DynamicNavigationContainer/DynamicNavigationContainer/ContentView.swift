//
//  ContentView.swift
//  DynamicNavigationContainer
//
//  Created by Yang Xu on 2022/11/12.
//

import Foundation
import SwiftUI

struct ContentView:View {
    @State var selection:Selection = .threeColumns
    var body: some View {
        TabView(selection: $selection){
            ThreeColumnsView()
                .tag(Selection.threeColumns)
                .tabItem{
                    Text("Three")
                }

            TowColumnsView()
                .tag(Selection.twoColumns)
                .tabItem{
                    Text("Two")
                }

            AdaptiveNavigatorView()
                .tag(Selection.adaptive)
                .tabItem{
                    Text("Adaptive")
                }
        }
    }
}

enum Selection:String {
    case threeColumns
    case twoColumns
    case adaptive
}
