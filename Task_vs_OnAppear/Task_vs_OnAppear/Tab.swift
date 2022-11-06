//
//  Tab.swift
//  Task_vs_OnAppear
//
//  Created by Yang Xu on 2022/9/27.
//

import Foundation
import SwiftUI

struct TabDemo:View{
    @State var selection = 3
    @State var go = false
    var body: some View{
        TabView(selection:$selection){
            Text("111")
                .onTapGesture {
                    selection = 2
                }
                .frame(maxWidth: .infinity,maxHeight: .infinity)
                .background(Color.secondary)
                .highPriorityGesture(DragGesture())
                .tag(1)


            Button("222"){
                selection = 1
            }
            .frame(maxWidth: .infinity,maxHeight: .infinity)
            .background(Color.orange)
            .highPriorityGesture(DragGesture())
            .tag(2)

        }
        .tabViewStyle(.page(indexDisplayMode: .never))
    }
}

struct TabDemoPreview:PreviewProvider{
    static var previews: some View{
        TabDemo()
    }
}
