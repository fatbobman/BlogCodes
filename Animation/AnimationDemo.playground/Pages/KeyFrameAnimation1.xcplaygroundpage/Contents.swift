import PlaygroundSupport
import SwiftUI

// 代码来自 https://swiftui-lab.com/swiftui-animations-part4/

struct KeyFrame {
    let offset: TimeInterval
    let rotation: Double
    let yScale: Double
    let y: CGFloat
    let animation: Animation?
}

let keyframes = [
    // Initial state, will be used once. Its offset is useless and will be ignored
    KeyFrame(offset: 0.0, rotation: 0, yScale: 1.0, y: 0, animation: nil),

    // Animation keyframes
    KeyFrame(offset: 0.2, rotation: 0, yScale: 0.5, y: 20, animation: .linear(duration: 0.2)),
    KeyFrame(offset: 0.4, rotation: 0, yScale: 1.0, y: -20, animation: .linear(duration: 0.4)),
    KeyFrame(offset: 0.5, rotation: 360, yScale: 1.0, y: -80, animation: .easeOut(duration: 0.5)),
    KeyFrame(offset: 0.4, rotation: 360, yScale: 1.0, y: -20, animation: .easeIn(duration: 0.4)),
    KeyFrame(offset: 0.2, rotation: 360, yScale: 0.5, y: 20, animation: .easeOut(duration: 0.2)),
    KeyFrame(offset: 0.4, rotation: 360, yScale: 1.0, y: -20, animation: .linear(duration: 0.4)),
    KeyFrame(offset: 0.5, rotation: 0, yScale: 1.0, y: -80, animation: .easeOut(duration: 0.5)),
    KeyFrame(offset: 0.4, rotation: 0, yScale: 1.0, y: -20, animation: .easeIn(duration: 0.4))
]

struct JumpingEmoji: View {
    // Use all offset, minus the first
    let offsets = Array(keyframes.map { $0.offset }.dropFirst())

    var body: some View {
        TimelineView(.cyclic(timeOffsets: offsets)) { timeline in
            HappyEmoji(date: timeline.date)
        }
        .frame(width: 400, height: 400)
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

struct CyclicTimelineSchedule: TimelineSchedule {
    let timeOffsets: [TimeInterval]

    func entries(from startDate: Date, mode: TimelineScheduleMode) -> Entries {
        Entries(last: startDate, offsets: timeOffsets)
    }

    struct Entries: Sequence, IteratorProtocol {
        var last: Date
        let offsets: [TimeInterval]

        var idx: Int = -1

        mutating func next() -> Date? {
            idx = (idx + 1) % offsets.count

            last = last.addingTimeInterval(offsets[idx])

            return last
        }
    }
}

extension TimelineSchedule where Self == CyclicTimelineSchedule {
    static func cyclic(timeOffsets: [TimeInterval]) -> CyclicTimelineSchedule {
        .init(timeOffsets: timeOffsets)
    }
}

PlaygroundPage.current.setLiveView(JumpingEmoji())
