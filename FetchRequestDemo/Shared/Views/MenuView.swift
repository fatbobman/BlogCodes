//
//  Menu.swift
//  FetchRequestDemo
//
//  Created by Yang Xu on 2022/4/21
//  Copyright © 2022 Yang Xu. All rights reserved.
//
//  Follow me on Twitter: @fatbobman
//  My Blog: https://www.fatbobman.com
//

import Foundation
import SwiftUI

struct MenuView: View {
    @State var showSetting = false
    @State var active = false
    @State var link: Links = .demo1
    var body: some View {
        ZStack {
            NavigationLink("", isActive: $active, destination: { link.destination }).frame(width: 0, height: 0)
            List {
                Button(Links.demo1.rawValue) {
                    link = .demo1
                    active.toggle()
                    Timer.demo1 = .now
                }
                Button(Links.demo2.rawValue) {
                    link = .demo2
                    active.toggle()
                    Timer.demo2 = .now
                }
                Button(Links.demo3.rawValue) {
                    link = .demo3
                    active.toggle()
                    Timer.demo3 = .now
                }
                Button(Links.demo4.rawValue) {
                    link = .demo4
                    active.toggle()
                    Timer.demo4 = .now
                }
                Button(Links.demo5.rawValue) {
                    link = .demo5
                    active.toggle()
                    Timer.demo5 = .now
                }
            }
        }
        .toolbar {
            ToolbarItem {
                Button(action: { showSetting.toggle() }, label: { Image(systemName: "gear") })
            }
        }
        .sheet(isPresented: $showSetting, content: { SettingView() })
    }
}

enum Links: String, Hashable {
    case demo1 = "仅显示数据，不支持跳转"
    case demo2 = "每行均有ID"
    case demo3 = "仅在顶部和底部设置ID"
    case demo4 = "通过UIKit方式跳转"
    case demo5 = "仅在Section上设置ID"

    @ViewBuilder
    var destination: some View {
        switch self {
        case .demo1:
            ListWithoutID()
        case .demo2:
            ListEachRowHasID()
        case .demo3:
            ListOnlyTopAndBottomHasID()
        case .demo4:
            ListUsingUIKitToScroll()
        case .demo5:
            SectionDemo()
        }
    }
}
