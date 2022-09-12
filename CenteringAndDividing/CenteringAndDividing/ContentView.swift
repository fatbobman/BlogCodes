//
//  ContentView.swift
//  CenteringAndDividing
//
//  Created by Yang Xu on 2022/8/28.
//

import SwiftUI

struct ContentView: View {

    var body: some View {
        NavigationView{
            VStack{
                List{
                    NavigationLink("明确尺寸", destination: ExplicitSizeDemo())
                    NavigationLink("不确定尺寸", destination: UnsureSizeDemo())
                }
                ZStack(alignment:.topLeading){
                    hello
                        .overlay(Rectangle().opacity(0.3).frame(width:300,height:60))
                        .border(Color.black, width: 2)
                    Text("hello")
                }
                .border(.red)
            }
        }
    }

    var hello: some View {
        Text("Hello world")
            .foregroundColor(.white)
            .font(.title)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
