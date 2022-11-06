//
//  PagingView.swift
//  ScrollView1
//
//  Created by Yang Xu on 2022/9/12.
//

import Foundation
import SolidScroll
import SwiftUI

struct PagingContentView: View {
    @State var height: CGFloat = 10
    var body: some View {
//      GeometryReader { proxy in
//        TabView {
        PView()
//                .setHeight(height: $height)

//            Text("abc")
//                .setHeight(height: $height)
//        }
//        .tabViewStyle(.page)
//          .frame(height:proxy.size.height)
            .sizeInfo("abc")
//        .frame(height: height)
//      }
    }
}

struct PView: View {
    var body: some View {
        SolidScrollView(config1) {
            VStack {
                ForEach(0..<100, id: \.self) {
                    Rectangle()
                        .fill(Color.blue)
                        .frame(height: 30)
                        .overlay(
                            Text("\($0)")
                                .foregroundColor(.red)
                        )
                }
            }
        }
//        .sizeInfo("inner scrollView")
    }
}

var config1: ScrollViewConfig {
    var config = ScrollViewConfig()
    config.gestureProvider = GestureProvider1()
    return config
}

var config2: ScrollViewConfig {
    var config = ScrollViewConfig()
    config.gestureProvider = GestureProvider2()
    return config
}

extension View {
    func setHeight(height: Binding<CGFloat>) -> some View {
        background(
            GeometryReader { proxy in
                Color.clear
                    .task(id: proxy.size) {
                        height.wrappedValue = proxy.size.height < 1000 ? 1000 : proxy.size.height
                    }
            }
        )
    }
}

struct GestureProvider1: _ScrollViewGestureProvider {
    func scrollableDirections(proxy: SwiftUI._ScrollViewProxy) -> SwiftUI._EventDirections {
        .vertical
    }

    func gestureMask(proxy: SwiftUI._ScrollViewProxy) -> SwiftUI.GestureMask {
        .all
    }
}

struct GestureProvider2: _ScrollViewGestureProvider {
    func scrollableDirections(proxy: SwiftUI._ScrollViewProxy) -> SwiftUI._EventDirections {
        .vertical
    }

    func gestureMask(proxy: SwiftUI._ScrollViewProxy) -> SwiftUI.GestureMask {
        .all
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
