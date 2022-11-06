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
        TabView{
            ListView()
                .tabItem{
                    Image(systemName: "heart")
                }

            Text("22")
                .tabItem{
                    Image(systemName: "circle")
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

let headerHeight: CGFloat = 240
let headerMinHeight: CGFloat = 40

var headerMaxHeight: CGFloat {
    (headerHeight + headerMinHeight) / 2
}

var distance: CGFloat {
    headerMaxHeight - headerMinHeight
}

struct ListView: View {
    @State var height: CGFloat = headerMaxHeight
    @State var overlayHeight: CGFloat = headerMaxHeight
    @State var minY: CGFloat = 0
    var body: some View {
        ZStack(alignment:.top) {
            TabView{
                ScrollView {
                    VStack(spacing: 0) {
                        Rectangle()
                            .fill(.clear)
                            .frame(height: overlayHeight) // top
                            .background(
                                GeometryReader { proxy in
                                    Color.clear
                                        .task(id: proxy.frame(in: .named("scrollview")).minY) {
                                            let minY = proxy.frame(in: .named("scrollview")).minY
                                            self.minY = minY
                                            height = minY < 0 ? max(headerMaxHeight + minY, headerMinHeight) : (height + minY) > headerMaxHeight ? headerMaxHeight : (height + minY)
                                            overlayHeight = minY < 0 ? max(headerMaxHeight + minY, headerMinHeight) + distance : (height + minY + distance)
                                        }
                                }
                            )
                        ForEach(0..<100, id: \.self) {
                            Text("\($0)").foregroundColor(.blue)
                                .frame(maxWidth: .infinity, minHeight: 40)
                                .background(.white)
                        }
                    }
                }

                .coordinateSpace(name: "scrollview")

                Text("abc")
            }
            .tabViewStyle(.page)
            .edgesIgnoringSafeArea(.bottom)
            .background(.green)


            Rectangle()
                .fill(Color.clear)
                .frame(height: height)
                .overlay(alignment: .top) {
                    Rectangle()
                        .fill(.red)
                        .frame(height: overlayHeight)
                        .overlay(alignment: .bottom) {
                            Text("Title")
                        }
                        .offset(y: minY < 0 ? max(minY, -distance) : 0)
                        .border(.black)

                }
                .zIndex(1)
                .allowsHitTesting(false)
        }
        .coordinateSpace(name: "VStack")
    }
}
