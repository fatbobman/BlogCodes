//
//  ContentView.swift
//  InlineImageWithText
//
//  Created by Yang Xu on 2022/8/13.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ScrollView{
            VStack(alignment: .leading, spacing:50) {
                VStack(alignment:.leading,spacing: 10){
                    Text("Image")
                        .foregroundColor(.blue)
                        .bold()
                        .textCase(.uppercase)
                    Demo1()
                }

                VStack(alignment:.leading,spacing: 10){
                    Text("Overlay")
                        .foregroundColor(.blue)
                        .bold()
                        .textCase(.uppercase)
                    Demo2()
                }

                VStack(alignment:.leading,spacing: 10){
                    Text("Dynamic Image")
                        .foregroundColor(.blue)
                        .bold()
                        .textCase(.uppercase)
                    Demo3()
                }
            }
            .frame(width:200)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
