//
//  ItemRow.swift
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

struct ItemRow:View{
    static var count = 0
    let item:Item
    init(item:Item){
        self.item = item
        print(Self.count)
        Self.count += 1
    }
    var body: some View{
//        let _ = print("get body value")
        Text(item.timestamp, format: .dateTime)
            .frame(minHeight:40)
    }
}
