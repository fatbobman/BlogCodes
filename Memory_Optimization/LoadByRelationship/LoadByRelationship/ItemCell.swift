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
    @State var show = true
    var body: some View {
        HStack {
            if show {
                Text(self.item.timestamp?.timeIntervalSince1970 ?? 0, format: .number)
                if let data = item.picture?.data, let uiImage = UIImage(data: data), let image = Image(uiImage: uiImage) {
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: self.imageSize.width, height: self.imageSize.height)
                }
            }
        }
        .frame(minWidth: .zero, maxWidth: .infinity)
        .onAppear {
            show = true
        }
        .onDisappear {
            show = false
            // 当将 Binary 保存在外部时,效果不大
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                viewContext.refresh(item, mergeChanges: false)
                if let picture = item.picture {
                    viewContext.refresh(picture, mergeChanges: false)
                }
            }
        }
    }
}
