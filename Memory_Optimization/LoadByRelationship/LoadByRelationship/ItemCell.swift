//
//  ItemCell.swift
//  LoadByRelationship
//
//  Created by Yang Xu on 2023/3/7.
//

import Foundation
import SwiftUI

struct ItemCell: View {
    @ObservedObject var item: Item
    @Environment(\.managedObjectContext) var viewContext
    let imageSize: CGSize = .init(width: 120, height: 160)
    var body: some View {
        HStack {
            Text(self.item.timestamp?.timeIntervalSince1970 ?? 0, format: .number)
            if let data = item.picture?.data, let uiImage = UIImage(data: data), let image = Image(uiImage: uiImage) {
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: self.imageSize.width, height: self.imageSize.height)
            }
        }
        .frame(minWidth: .zero, maxWidth: .infinity)
        .onDisappear {
//            viewContext.refresh(item, mergeChanges: false) // 并不会释放行缓存
        }
    }
}
