//
//  Row.swift
//  SwiftDataPreview
//
//  Created by Yang Xu on 2023/9/13.
//

import SwiftUI

struct ItemRow:View {
    let item:Item
    var body: some View {
        Text("Item at \(item.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))")
    }
}
