//
//  ContentView.swift
//  MyZStack
//
//  Created by Yang Xu on 2022/6/30
//  Copyright © 2022 Yang Xu. All rights reserved.
//
//  Follow me on Twitter: @fatbobman
//  My Blog: https://www.fatbobman.com
//

import SwiftUI

struct ContentView: View {
    let alignment: Alignment = .leadingFirstTextBaseline
    var body: some View {
        HStack(alignment: .firstTextBaseline) {
            ZStack(alignment: alignment) {
                Text("山不在高，有仙则名。水不在深，有龙则灵。斯是陋室，惟吾德馨。苔痕上阶绿，草色入帘青。谈笑有鸿儒，往来无白丁。可以调素琴，阅金经。无丝竹之乱耳，无案牍之劳形。南阳诸葛庐，西蜀子云亭。孔子云：何陋之有？")
                    .frame(width: 80)
                Color.red.opacity(0.5)
                    .frame(width: 100, height: 100)
                Text("肘子的Swift记事本")
                    .frame(width: 80, height: 80, alignment: .top)
            }
            .border(.blue)

            MyZStack(alignment: alignment) {
                Text("山不在高，有仙则名。水不在深，有龙则灵。斯是陋室，惟吾德馨。苔痕上阶绿，草色入帘青。谈笑有鸿儒，往来无白丁。可以调素琴，阅金经。无丝竹之乱耳，无案牍之劳形。南阳诸葛庐，西蜀子云亭。孔子云：何陋之有？")
                    .frame(width: 80)
                Color.red.opacity(0.5)
                    .frame(width: 100, height: 100)
                Text("肘子的Swift记事本")
                    .frame(width: 80, height: 80, alignment: .top)
            }
            .border(.blue)

            Text("山不在高，有仙则名。水不在深，有龙则灵。斯是陋室，惟吾德馨。苔痕上阶绿，草色入帘青。")
                .frame(width: 60)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
