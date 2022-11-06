//
//  ScrollWithHeader.swift
//  ScrollView1
//
//  Created by Yang Xu on 2022/9/13.
//

import Foundation
import SwiftUI


final class HeaderStore:ObservableObject{
    static let headerHeight:CGFloat = 200
    static let headerMinHeight:CGFloat = 40

    @Published var placeholderBottom:CGFloat = 0{
        didSet{
            headerCurrentHeight = placeholderBottom < HeaderStore.headerMinHeight ? HeaderStore.headerMinHeight : placeholderBottom
        }
    }

    var headerCurrentHeight: CGFloat = HeaderStore.headerHeight
}


struct RootContainer:View{
    @StateObject var store = HeaderStore()
    var body: some View{
        ZStack(alignment:.top){
            TabView {
                ScrollViewReader{ reader in
                    ScrollView{
                        Rectangle()
                            .fill(Color.clear)
                            .frame(height:HeaderStore.headerHeight)
                            .background(
                                GeometryReader{ proxy in
                                    let maxY = proxy.frame(in: .named("s1")).maxY
                                    Color.clear
                                        .task(id:maxY) {
                                            store.placeholderBottom = maxY
                                        }
                                }
                            )

                        // top
                        Rectangle()
                            .frame(height:0)
                            .id("top")

                        LazyVStack(spacing:0){
                            ForEach(0..<100,id:\.self){ i in
                                Text("\(i)")
                                    .frame(maxWidth: .infinity,minHeight: 40)
                                    .background(.white)
                            }
                        }
                    }
                    .coordinateSpace(name: "s1")
                    .onAppear{ print("s1")}
                    .onDisappear{
                        reader.scrollTo("top",anchor: .top)
                    }

                }


                ScrollView{
                    Rectangle()
                        .fill(Color.clear)
                        .frame(height:HeaderStore.headerHeight)
                        .background(
                            GeometryReader{ proxy in
                                let maxY = proxy.frame(in: .named("s2")).maxY
                                Color.clear
                                    .task(id:maxY) {
                                        store.placeholderBottom = maxY
                                    }
                            }
                        )
                    LazyVStack(spacing:0){
                        ForEach(0..<100,id:\.self){ i in
                            Text("\(i)")
                                .frame(maxWidth: .infinity,minHeight: 40)
                                .background(.white)
                        }
                    }
                }
                .coordinateSpace(name: "s2")
                .onAppear{ print("s2")}


                Text("222")
                    .frame(maxWidth: .infinity,maxHeight: .infinity)
                    .background(.yellow)
            }
            .tabViewStyle(.page)
            .edgesIgnoringSafeArea(.bottom)

            // Header
            Header(store: store){
                Rectangle()
                    .fill(.red)
                    .frame(maxWidth: .infinity,minHeight: 300)
                    .allowsHitTesting(false)
                    .overlay(alignment:.bottom){
                        Text("Title")
                            .onTapGesture {
                                print("hit title")
                            }
                    }



            }
        }
        .background(.red)
    }
}

struct Header<Content:View>:View{
    @ObservedObject var store:HeaderStore
    var content:Content
    init(store: HeaderStore, @ViewBuilder content: () -> Content) {
        self.store = store
        self.content = content()
    }
    var body: some View{
        Rectangle()
            .fill(.clear)
            .frame(height: store.headerCurrentHeight)
            .overlay(alignment:.bottom){
                content
            }
    }
}
