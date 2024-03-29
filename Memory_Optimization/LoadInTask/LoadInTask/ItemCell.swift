//
//  ItemCell.swift
//  LoadInTask
//
//  Created by Yang Xu on 2023/3/6.
//

import Foundation
import SwiftUI

struct ItemCell: View {
    @ObservedObject var item: Item
    @StateObject var imageHolder = ImageHolder()
    @Environment(\.managedObjectContext) var viewContext
    let imageSize: CGSize = .init(width: 120, height: 160)
    @State var show = true
    var body: some View {
        HStack {
            Text(self.item.timestamp?.timeIntervalSince1970 ?? 0, format: .number)
            Color.clear
                .frame(width: self.imageSize.width, height: self.imageSize.height)
                .overlay(
                    Group {
                        if show,let image = imageHolder.image {
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: self.imageSize.width, height: self.imageSize.height)
                        }
                    }
                )
        }
        .frame(minWidth: .zero, maxWidth: .infinity)
        .onAppear {
            show = true
            Task {
                if let objectID = item.picture?.objectID {
                    let imageData: Data? = await PersistenceController.shared.container.performBackgroundTask { context in
                        if let picture = try? context.existingObject(with: objectID) as? Picture, let data = picture.data {
                            return data
                        } else { return nil }
                    }
                    if let imageData {
                        imageHolder.image = Image(uiImage: UIImage(data: imageData)!)
                    }
                }
            }
        }
        .onDisappear {
            show = false
            self.imageHolder.image = nil
        }
    }
}

class ImageHolder: ObservableObject {
    @Published var image: Image?
}
