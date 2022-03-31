import Foundation
import SwiftUI

public protocol AttributedText {
    var content: AttributedString { get }
    init(_ attributed: AttributedString)
}

extension AttributedString: AttributedText {
    public var content: AttributedString {
        self
    }

    public init(_ attributed: AttributedString) {
        self = attributed
    }
}

public extension AttributedText {
    func transform(_ perform: (inout AttributedString) -> Void) -> Self {
        var attributedString = self.content
        perform(&attributedString)
        return Self(attributedString)
    }

    func color(_ color: Color) -> AttributedText {
        transform { $0.foregroundColor = color }
    }

    func bold() -> AttributedText {
        transform { $0.inlinePresentationIntent = .stronglyEmphasized }
    }
}
