//
//  KingfisherDemo.swift
//  Lazy_ForEach_Bug
//
//  Created by Yang Xu on 2022/9/22.
//

import Foundation
import Kingfisher
import SwiftUI

struct KingfisherDemo_WrongVersion: View {
    let url = URL(string: "https://loremflickr.com/200/300")
    var body: some View {
        List {
            ForEach(0..<30) { _ in
                VStack {
                    KFImage.url(url) // 没有紧贴 ForEach
                        .placeholder { _ in Text("Place holder") }
                        .loadDiskFileSynchronously()
                        .cacheMemoryOnly()
                        .fade(duration: 0.25)
                        .onProgress { _, _ in }
                        .onSuccess { _ in }
                        .onFailure { _ in }
                }
            }
        }
    }
}

struct KingfisherDemo_RightVersion: View {
    let url = URL(string: "https://loremflickr.com/200/300")
    @State var image: Image?
    var body: some View {
        List {
            ForEach(0..<30) { _ in
                VStack {
                    if let image {
                        image
                    } else {
                        KFImage.url(url) // 没有紧贴 ForEach
                            .placeholder { _ in Text("Place holder") }
                            .loadDiskFileSynchronously()
                            .cacheMemoryOnly()
                            .fade(duration: 0.25)
                            .onProgress { _, _ in }
                            .onSuccess { result in
                                if let cgImage = result.image.cgImage {
                                    self.image = Image(decorative: cgImage, scale: 1)
                                }
                            }
                            .onFailure { _ in }
                    }
                }
            }
        }
    }
}
