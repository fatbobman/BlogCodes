import PlaygroundSupport
import SwiftUI

struct MyTransition: ViewModifier {
    let rotation: Angle
    func body(content: Content) -> some View {
        content
            .rotationEffect(rotation)
    }
}

extension AnyTransition {
    static var rotation: AnyTransition {
        AnyTransition.modifier(
            active: MyTransition(rotation: .degrees(360)),
            identity: MyTransition(rotation: .zero)
        )
    }
}

struct CustomTransitionDemo: View {
    @State var show = true
    var body: some View {
        VStack {
            Spacer()
            Text("Hello")
            if show {
                Text("World")
                    .transition(.rotation.combined(with: .opacity))
            }

            Spacer()
            Button(show ? "Hide" : "Show") {
                show.toggle()
            }
        }
        .animation(.easeInOut(duration: 2), value: show)
        .frame(width: 300, height: 300)
        .onChange(of:show){
            print($0)
        }
    }
}

PlaygroundPage.current.setLiveView(CustomTransitionDemo())
