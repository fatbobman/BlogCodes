//
//  Background.swift
//  Centering
//
//  Created by Yang Xu on 2022/8/29.
//

import Foundation
import SwiftUI

struct BackgroundView: View {
    var body: some View {
        VStack {
            Text("Hello World").foregroundColor(.white).font(.title)
                .frame(maxWidth: .infinity)
                .frame(height: 200)
                .background(.orange,ignoresSafeAreaEdges: [])
            // 保留顶部空间

            Text("Hello World").foregroundColor(.white).font(.title)
                .frame(maxWidth: .infinity)
                .frame(height: 200)
                .background(.blue)

            Spacer()
        }
    }
}

struct Background_Preview:PreviewProvider{
    static var previews: some View{
        BackgroundView()
    }
}
