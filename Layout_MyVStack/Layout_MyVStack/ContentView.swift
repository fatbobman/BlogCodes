//
//  ContentView.swift
//  Layout_MyVStack
//
//  Created by Yang Xu on 2022/6/27
//  Copyright © 2022 Yang Xu. All rights reserved.
//
//  Follow me on Twitter: @fatbobman 
//  My Blog: https://www.fatbobman.com
//


import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            List{
                ForEach(Links.allCases) { link in
                    NavigationLink(link.rawValue,value:link)
                }
            }
            .navigationDestination(for: Links.self){ link in
                switch link {
                    case .version1:
                        MyVStack1_Demo()
                    case .version2:
                        MyVStack2_Demo()
                    case .version3:
                        Text("")
                }
            }
        }
    }
}

enum Links:String,CaseIterable,Identifiable,Hashable{
    case version1 = "第一版"
    case version2 = "第二版"
    case version3 = "第三版"

    var id:Self{
        self
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
