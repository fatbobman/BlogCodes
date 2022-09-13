//
//  ContentView.swift
//  ScrollView1
//
//  Created by Yang Xu on 2022/9/12.
//

import SolidScroll
import SwiftUI

struct ContentView: View {
    var body: some View {
//        TabView {
        ListView()

//        VStack(spacing: 0) {
//            SolidScrollView(config) {
//                VStack(spacing: 0) {
//                    Color.red.frame(height: 200)
//                    Color.green.frame(height: 200)
//                    Color.blue.frame(height: 200)
//                    Color.black.frame(height: 200)
//                }
//            }
//        }

//                .tabItem {
//                    Image(systemName: "heart")
//                }
//
//            Text("22")
//                .tabItem {
//                    Image(systemName: "circle")
//                }
//        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

let headerMaxHeight:CGFloat = 200
let headerMinHeight:CGFloat = 40
var distance:CGFloat {
    headerMaxHeight - headerMinHeight
}

struct ListView: View {
    @State var height: CGFloat = headerMaxHeight
    @State var overlayHeight: CGFloat = headerMaxHeight
    @State var minY:CGFloat = 0
    var body: some View {
        VStack(spacing: 0) {
            Rectangle()
                .fill(Color.clear.gradient)
                .frame(height: height)
                .sizeInfo("placeholder")
                .overlay(alignment: .top) {
                    Rectangle()
                        .fill(.red)
                        .frame(height: overlayHeight)
                        .overlay(alignment:.bottom){
                            Text("Title")
                        }
                        .offset(y: minY < 0 ? max(minY,-distance) : 0)
                        .sizeInfo("overlay")

                }
                .zIndex(1)
            ScrollView {
                VStack(spacing:0) {
                    Rectangle()
                        .frame(height: distance) // top
                        .background(
                            GeometryReader { proxy in
                                Color.clear
                                    .task(id: proxy.frame(in: .named("scrollview")).minY) {
                                        let minY = proxy.frame(in: .named("scrollview")).minY
                                        self.minY = minY
                                        height = minY < 0 ? max(headerMaxHeight + minY, headerMinHeight) : (height + minY) > headerMaxHeight ? headerMaxHeight : (height + minY)
                                        overlayHeight = minY < 0 ? max(headerMaxHeight + minY, headerMinHeight) + distance : (height + minY + distance)
                                        print(minY,height,overlayHeight)
                                    }
                            }
                        )
                    ForEach(0..<100, id: \.self) {
                        Text("\($0)").foregroundColor(.blue)
                            .frame(maxWidth: .infinity, minHeight: 40)
                            .background(.white)
                            .border(.blue)
                    }
                }
            }
            .coordinateSpace(name: "scrollview")
        }
        .background(.red)
        .coordinateSpace(name: "VStack")
    }
}

extension View {
    func sizeInfo(_ id: String = "") -> some View {
        background(
            GeometryReader { proxy in
                Color.clear
                    .task(id: proxy.size) {
                        print(id, proxy.size)
                    }
            }
        )
    }
}
