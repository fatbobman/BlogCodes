//
//  ContentView.swift
//  Lazy_ForEach_Bug
//
//  Created by Yang Xu on 2022/9/21.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            List {
                NavigationLink("LazyVStack: State Not in level one", destination: Demo2())
                NavigationLink("LazyVStack: State in level one", destination: Demo1())
                NavigationLink("List: State Not in level one", destination: Demo4())
                NavigationLink("List: State in level one", destination: Demo3())
                if #available(iOS 15, *) {
                    NavigationLink("AsyncImage_LazyVStack: Not in level one", destination: AsyncImageDemoWrongVersion_LazyVStack())
                    NavigationLink("AsyncImage_List: Not in level one", destination: AsyncImageDemoWrongVersion_List())
                    NavigationLink("AsyncImage_List: in level one", destination: AsyncImageDemoRightVersion_List())
                    NavigationLink("AsyncImage_LazyVStack: Hold Image", destination: AsyncImageDemoRightVersion_LazyVStack())
                }
                NavigationLink("Kingfisher Not Hold Image in iOS 16",destination: KingfisherDemo_WrongVersion())
                NavigationLink("Kingfisher Hold Image in iOS 16",destination: KingfisherDemo_RightVersion())
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
