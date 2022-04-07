import Foundation

public protocol ViewModifier {
    associatedtype Body: View
    typealias Content = _ViewModifier_Content<Self>
    @ViewBuilder func body(content: Content) -> Self.Body
}

public struct _ViewModifier_Content<Modifier>: View where Modifier: ViewModifier {
    public typealias Body = Never
    public var body: Never { fatalError() }
}

public struct ModifiedContent<Content, Modifier>: View where Content: View, Modifier: ViewModifier {
    public typealias Body = Never
    public var content: Content
    public var modifier: Modifier
    public init(content: Content, modifier: Modifier) {
        self.content = content
        self.modifier = modifier
    }

    public var body: ModifiedContent<Content, Modifier>.Body {
        fatalError()
    }
}

public struct _OverlayModifier<Overlay>: ViewModifier where Overlay: View {
    public var overlay: Overlay
    public init(overlay: Overlay) {
        self.overlay = overlay
    }

    public func body(content: Content) -> Never {
        fatalError()
    }
}
