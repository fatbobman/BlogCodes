//
//  AVPlayer.swift
//  Task_vs_OnAppear
//
//  Created by Yang Xu on 2022/9/26.
//

import AVKit
import Foundation
import SwiftUI

struct AVPlayerDemo: View {
    @State var showFullScreenVideo = false
    var body: some View {
        VStack {
            Button("Play Video in full screen ") {
                showFullScreenVideo.toggle()
            }
        }
        .fullScreenCover(isPresented: $showFullScreenVideo) {
            VideoPlayer(player: AVPlayer(url: URL(string: "https://cdn.fatbobman.com/SwipeCellDemoVideo.mp4")!)) {
                if #available(iOS 16, *) {
                    Image(systemName: "plus.circle.fill")
                        .font(.largeTitle)
                        .rotationEffect(.degrees(45))
                        .offset(x: 30, y: 40) // 用 alignmentGuide 调整也可以
                        .opacity(0.8)
                        .foregroundColor(.secondary)
                        .onTapGesture {
                            showFullScreenVideo = false
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                }
            }
            .toolbar(.hidden, for: .automatic)
            .ignoresSafeArea() // 开启全屏播放模式的关键
        }
    }
}

struct AVPlayerDemo_Preview:PreviewProvider{
    static var previews: some View{
        AVPlayerDemo()
    }
}
