//
//  ContentView.swift
//  My_Frame
//
//  Created by Yang Xu on 2022/7/5
//  Copyright © 2022 Yang Xu. All rights reserved.
//
//  Follow me on Twitter: @fatbobman
//  My Blog: https://www.fatbobman.com
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        //        VStack(alignment: .leading) {
        //            Text("abc asgljk asdg;lkjasdg ;lkjsdg ")
        //                .frame(width: 30, alignment: .leading)
        //                .fixedSize(horizontal: false, vertical: false)
        //                .border(.red)
        //
        //            Text("abc asgljk asdg;lkjasdg ;lkjsdg ")
        //                .myFrame(width: 30, alignment: .leading)
        //                .fixedSize(horizontal: false, vertical: false)
        //                .border(.red)
        //
        //        }
        //        .frame(width:50)
        ////        .border(.red)

        //        VStack {
        ////            Text("如果指定了一个最小约束，并且父类为框架建议的尺寸小于这个视图的尺寸，那么建议的")
        //            Rectangle()
        //                .lineLimit(2...3)
        //                .frame(maxWidth: 200,  maxHeight: 200,alignment: .trailingLastTextBaseline)
        //                .border(.red)
        //                .fixedSize(horizontal: true, vertical: false)
        //                .printSizeInfo()
        //
        ////            Text("如果指定了一个最小约束，并且父类为框架建议的尺寸小于这个视图的尺寸，那么建议的")
        //            Rectangle()
        //                .lineLimit(2...3)
        //                .frame(maxWidth: 200, maxHeight: 200,alignment:.trailingLastTextBaseline)
        //                .border(.red)
        //                .myFixedSize(horizontal: true, vertical: false)
        //                .printSizeInfo()
        //        }
        //        .frame(width: 300)

        VStack(spacing: 20) {
            let str = "山不在高，有仙则名。水不在深，有龙则灵。斯是陋室，惟吾德馨。苔痕上阶绿，草色入帘青。谈笑有鸿儒，往来无白丁。可以调素琴，阅金经。无丝竹之乱耳，无案牍之劳形。南阳诸葛庐，西蜀子云亭。孔子云：何陋之有？"

            Rectangle()
                .myFixedSize()

            Text(str)
                .myFixedSize(horizontal: false, vertical: true)

            Text(str)
                .frame(maxWidth: 100)
                .myFixedSize()

            Text(str)
                .frame(minWidth: 50, idealWidth: 120, maxWidth: 150)
                .myFixedSize()

            Text(str)
                .frame(maxHeight: 50)
                .myFixedSize(horizontal: false, vertical: true)
        }
        .frame(width: 200, height: 30)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

extension View {
    func printSizeInfo(_ label: String = "") -> some View {
        background(
            GeometryReader { proxy in
                Color.clear
                    .task(id: proxy.size) {
                        print(label, proxy.size)
                    }
            }
        )
    }
}
