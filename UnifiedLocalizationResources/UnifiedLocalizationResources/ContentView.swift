//
//  ContentView.swift
//  UnifiedLocalizationResources
//
//  Created by Yang Xu on 2022/11/6.
//

import PackageA
import PackageB
import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            ViewA()
            ViewB()
            Text("MAIN_APP", bundle: .i18n)
                .foregroundColor(Color("i18nColor", bundle: .i18n))
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environment(\.locale, .init(identifier: "zh-cn"))
    }
}
