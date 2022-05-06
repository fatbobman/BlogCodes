import PlaygroundSupport
import SwiftUI

// 采用 task 来驱动更新状态。

struct KeyFrame {
    let offset: TimeInterval
    let rotation: Double
    let yScale: Double
    let y: CGFloat
    let animation: Animation?
}

let keyframes = [
    // Animation keyframes
    KeyFrame(offset: 0.0, rotation: 0, yScale: 1.0, y: 0, animation: nil),
    KeyFrame(offset: 0.2, rotation: 0, yScale: 0.5, y: 20, animation: .linear(duration: 0.2)),
    KeyFrame(offset: 0.4, rotation: 0, yScale: 1.0, y: -20, animation: .linear(duration: 0.4)),
    KeyFrame(offset: 0.5, rotation: 360, yScale: 1.0, y: -80, animation: .easeOut(duration: 0.5)),
    KeyFrame(offset: 0.4, rotation: 360, yScale: 1.0, y: -20, animation: .easeIn(duration: 0.4)),
    KeyFrame(offset: 0.2, rotation: 360, yScale: 0.5, y: 20, animation: .easeOut(duration: 0.2)),
    KeyFrame(offset: 0.4, rotation: 360, yScale: 1.0, y: -20, animation: .linear(duration: 0.4)),
    KeyFrame(offset: 0.5, rotation: 0, yScale: 1.0, y: -80, animation: .easeOut(duration: 0.5)),
    KeyFrame(offset: 0.4, rotation: 0, yScale: 1.0, y: -20, animation: .easeIn(duration: 0.4)),
    KeyFrame(offset: 0.2, rotation: 0, yScale: 0.5, y: 20, animation: .easeOut(duration: 0.2))
]

struct JumpingEmoji: View {
    let offsets = keyframes.map(\.offset).dropFirst()

    @State var update = Date.now

    var body: some View {
        HappyEmoji(date: update)
            .frame(width: 300, height: 400)
            .task {
                while true {
                    for offset in offsets {
                        try? await Task.sleep(nanoseconds: UInt64(1000000000 * offset))
                        self.update = .now
                    }
                }
            }
    }
}

struct HappyEmoji: View {
    // current keyframe number
    @State var idx = 0

    // timeline update
    let date: Date

    var body: some View {
        Text("😃")
            .font(.largeTitle)
            .scaleEffect(4.0)
            .modifier(Effects(keyframe: keyframes[idx]))
            .animation(keyframes[idx].animation, value: idx)
            .onChange(of: date) { _ in advanceKeyFrame() }
            .onAppear { advanceKeyFrame() }
    }

    func advanceKeyFrame() {
        // advance to next keyframe
        idx = (idx + 1) % keyframes.count

        // skip first frame for animation, which we
        // only used as the initial state.
        if idx == 0 { idx = 1 }
    }

    struct Effects: ViewModifier {
        let keyframe: KeyFrame

        func body(content: Content) -> some View {
            content
                .scaleEffect(CGSize(width: 1.0, height: keyframe.yScale))
                .rotationEffect(Angle(degrees: keyframe.rotation))
                .offset(y: keyframe.y)
        }
    }
}

PlaygroundPage.current.setLiveView(JumpingEmoji())
