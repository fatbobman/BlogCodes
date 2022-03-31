import Foundation
import SwiftUI

public extension AttributedString {
    func color(_ color: Color) -> AttributedString {
        then { $0.foregroundColor = color }
    }

    func bold() -> AttributedString {
        then { $0.inlinePresentationIntent = .stronglyEmphasized }
    }

    func then(_ perform: (inout Self) -> Void) -> Self {
        var result = self
        perform(&result)
        return result
    }
}

@available(macOS 13.0, iOS 16.0,*)
public extension AttributedString {
    func futureMethod() -> AttributedString {
        self
    }
}
