//
//  ListWithTask.swift
//  Task_vs_OnAppear
//
//  Created by Yang Xu on 2022/9/26.
//

import Foundation
import SwiftUI

struct ListWithTask: View {
    @State var count = 0
    var body: some View {
        VStack {
            Text("count: \(count)")
            ScrollView {
                LazyVStack {
                    ForEach(0..<100) { i in
                        HStack {
                            Text("\(i)")
                        }
                        // 滚动到最底部时，count 应该为 100
                        .task {
                            count += 1
                            print(i)
                        }
                    }
                }
            }
        }
    }
}
