import Foundation

public struct Container: AttributedText {
    public var content: AttributedString

    public init(_ attributed: AttributedString) {
        content = attributed
    }

    public init(@AttributedTextBuilder _ attributedText: () -> AttributedText) {
        self.content = attributedText().content
    }
}
