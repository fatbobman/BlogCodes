//
//  AsyncDemo.swift
//  Lazy_ForEach_Bug
//
//  Created by Yang Xu on 2022/9/22.
//

import Foundation
import SwiftUI

@available(iOS 15,*)
struct AsyncImageDemoWrongVersion_LazyVStack: View {
    let url = URL(string: "https://loremflickr.com/200/300")

    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(0..<20) { _ in
                    VStack {
                        AsyncImage(url: url) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                        } placeholder: {
                            Image(systemName: "photo")
                                .imageScale(.large)
                                .frame(width: 110, height: 110)
                        }
                    }
                }
            }
        }
    }
}

@available(iOS 15,*)
struct AsyncImageDemoWrongVersion_List: View {
    let url = URL(string: "https://loremflickr.com/200/300")

    var body: some View {
        List {
            ForEach(0..<20) { _ in
                VStack {
                    AsyncImage(url: url) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    } placeholder: {
                        Image(systemName: "photo")
                            .imageScale(.large)
                            .frame(width: 110, height: 110)
                    }
                }
            }
        }
    }
}

@available(iOS 15,*)
struct AsyncImageDemoRightVersion_List: View {
    let url = URL(string: "https://loremflickr.com/200/300")

    var body: some View {
        List {
            ForEach(0..<20) { _ in
                AsyncImage(url: url) { image in
                    VStack { // VStack in AsyncImage
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    }
                } placeholder: {
                    Image(systemName: "photo")
                        .imageScale(.large)
                        .frame(width: 110, height: 110)
                }
            }
        }
    }
}

@available(iOS 15,*)
struct AsyncImageDemoRightVersion_LazyVStack: View {
    let url = URL(string: "https://loremflickr.com/200/300")
    var body: some View {
        List {
            ForEach(0..<20) { _ in
                ImageSubView(url: url)
            }
        }
    }
}

@available(iOS 15,*)
struct ImageSubView: View {
    let url: URL?
    @State var image: Image?
    var body: some View {
        VStack {
            if let image {
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            } else {
                AsyncImage(url: url) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .task {
                            self.image = image
                        }
                } placeholder: {
                    Image(systemName: "photo")
                        .imageScale(.large)
                        .frame(width: 110, height: 110)
                }
            }
        }
    }
}

