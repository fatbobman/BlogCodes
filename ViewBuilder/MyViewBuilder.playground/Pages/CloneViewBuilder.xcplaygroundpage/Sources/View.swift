import Foundation

public protocol View {
    associatedtype Body: View
    @ViewBuilder var body: Self.Body { get }
}

extension Never: View {
    public typealias Body = Never
    public var body: Never { fatalError() }
}

public struct EmptyView: View {
    public typealias Body = Never
    public var body: Never { fatalError() }
    public init() {}
}

protocol TypeErasing {
    var view: Any { get }
}

public struct AnyView: View {
    var eraser: TypeErasing
    public var body: Never { fatalError() }
    public init<V>(_ content: V) where V: View {
        self.eraser = ViewEraser(content)
    }

    var wrappedView: Any {
        eraser.view
    }

    class ViewEraser<V: View>: TypeErasing {
        let originalView: V
        var view: Any {
            originalView
        }

        init(_ view: V) {
            self.originalView = view
        }
    }
}

public struct _ConditionalContent<TrueContent, FalseContent>: View {
    public var body: Never { fatalError() }
    let storage: Storage
    enum Storage {
        case trueContent(TrueContent)
        case falseContent(FalseContent)
    }

    init(storage: Storage) {
        self.storage = storage
    }
}

public struct TupleView<T>: View {
    var content: T
    public var body: Never { fatalError() }
    public init(_ content: T) {
        self.content = content
    }
}

public struct Group<Content>: View {
    var content: Content
    public var body: Never { fatalError() }
    public init(@ViewBuilder _ content: () -> Content) {
        self.content = content()
    }
}

struct IDView<Content, ID>: View where Content: View, ID: Hashable {
    var content: Content
    var id: ID
    var body: Never { fatalError() }
    init(_ content: Content, id: ID) {
        self.content = content
        self.id = id
    }
}

public struct Text: View {
    public typealias Body = Never
    public var body: Never { fatalError() }
    var content: String // SwiftUI 这里的数据是有SwiftUI托管的，并且可以保存多种类型
    var modifiers: [Modifier] = []
    public init(_ content: String) {
        self.content = content
    }
}

public extension Text {
    enum Modifier {
        case color(Color?)
    }

    func foregroundColor(_ color: Color?) -> Text {
        guard !modifiers.contains(where: {
            if case .color = $0 { return true } else { return false }
        }) else { return self }
        var text = self
        text.modifiers.append(.color(color))
        return text
    }
}

public struct Color {
    let rawValue: Int
    public static let red = Color(rawValue: 0)
    public static let blue = Color(rawValue: 1)
    public static let green = Color(rawValue: 2)
}

public extension View {
    func modifier<T>(_ modifier: T) -> ModifiedContent<Self, T> {
        .init(content: self, modifier: modifier)
    }

    func overlay<Overlay>(_ overlay: Overlay) -> some View where Overlay: View {
        modifier(_OverlayModifier(overlay: overlay))
    }

    func overlay<Overlay>(@ViewBuilder _ overlay: () -> Overlay) -> some View where Overlay: View {
        modifier(_OverlayModifier(overlay: overlay()))
    }

    func id<ID>(_ id: ID) -> some View where ID: Hashable {
        IDView(self, id: id)
    }
}
