//
//  ContentView.swift
//  Shared
//
//  Created by Yang Xu on 2022/4/21
//  Copyright © 2022 Yang Xu. All rights reserved.
//
//  Follow me on Twitter: @fatbobman
//  My Blog: https://www.fatbobman.com
//

import CoreData
import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            MenuView()
                .onAppear{
                    ItemRow.count = 0
                    print("reset item row count")
                }
            Text("选择演示")
        }
        .navigationViewStyle(.columns)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
