import Foundation

struct ContentView: View {
    var selection: Int
    var body: some View {
        Group {
            switch selection {
            case 1:
                Text("喜羊羊")
                    .foregroundColor(.red)
            case 2:
                Text("灰太狼")
            default:
                Text("懒羊羊")
                    .modifier(MyModifier())
            }

            if #available(macOS 13, iOS 16,*) {
                MyText()
            }
        }
        .overlay(Text("Overlay"))
    }
}

// ModifiedContent<Group<TupleView<(_ConditionalContent<_ConditionalContent<Text, Text>, ModifiedContent<Text, MyModifier>>, _ConditionalContent<AnyView, EmptyView>)>>, _OverlayModifier<Text>>

@available(macOS 13, iOS 16,*)
struct MyText: View {
    var body: some View {
        Text("Hello , Future")
    }
}

public struct MyModifier: ViewModifier {
    public func body(content: Content) -> some View {
        content
    }
}

ContentView(selection: 2).body.debug()
