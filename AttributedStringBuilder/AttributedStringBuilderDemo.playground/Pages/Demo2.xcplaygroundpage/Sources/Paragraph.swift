import Foundation

public struct Paragraph: AttributedText {
    public var content: AttributedString
    public init(_ attributed: AttributedString) {
        content = attributed
    }

    public init(@AttributedTextBuilder _ attributedText: () -> AttributedText) {
        self.content = "\n" + attributedText().content + "\n"
    }
}
