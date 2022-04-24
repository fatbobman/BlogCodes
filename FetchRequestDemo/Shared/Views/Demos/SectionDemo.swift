//
//  SectionDemo.swift
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

struct SectionDemo: View {
    @SectionedFetchRequest(sectionIdentifier: \Item.section, sortDescriptors: [SortDescriptor(\Item.timestamp)])
    var sectionItems: SectionedFetchResults
    @State var showInfo = false
    var body: some View {
        ScrollViewReader { proxy in
            VStack {
                List {
                    ForEach(sectionItems) { section in
                        Section {
                            ForEach(section) { item in
                                ItemRow(item: item)
                            }
                        } header: {
                            Text(String(Int(section.id)))
                                .id(Int(section.id))
                        }
                    }
                }
                .listStyle(.inset)
                HStack {
                    ForEach(0..<10) { i in
                        Button("\(i)") {
                            withAnimation {
                                proxy.scrollTo(i, anchor: .top)
                            }
                        }
                    }
                }
            }
        }
        .toolbar {
            Button("Info") {
                showInfo.toggle()
            }
        }
        .sheet(isPresented: $showInfo, content: { info() })
        .onAppear {
            print(Date().timeIntervalSince(Timer.demo5))
        }
    }

    @ViewBuilder
    func info() -> some View {
        VStack {
            if let section = sectionItems.last,
               let item = section.last,
               let result = item.isFault ? "is" : "isn't" {
                Text(LocalizedStringKey("The last one **\(result)** fault"))
            }
        }
    }
}
