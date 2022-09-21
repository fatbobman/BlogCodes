//
//  ContentView.swift
//  Lazy_ForEach_Bug
//
//  Created by Yang Xu on 2022/9/21.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView{
            List {
                NavigationLink("LazyVStack: State Not in level one", destination: Demo2())
                NavigationLink("LazyVStack: State in level one", destination: Demo1())
                NavigationLink("List: State Not in level one", destination: Demo4())
                NavigationLink("List: State in level one", destination: Demo3())
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

