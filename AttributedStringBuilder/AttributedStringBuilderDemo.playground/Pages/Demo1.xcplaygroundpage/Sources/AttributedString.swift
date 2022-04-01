import Foundation
import SwiftUI

public extension AttributedString {
    func color(_ color: Color) -> AttributedString {
        then {
            $0.foregroundColor = color
        }
    }

    func bold() -> AttributedString {
        return then {
            if var inlinePresentationIntent = $0.inlinePresentationIntent {
                var container = AttributeContainer()
                inlinePresentationIntent.insert(.stronglyEmphasized)
                container.inlinePresentationIntent = inlinePresentationIntent
                let _ = $0.mergeAttributes(container)
            } else {
                $0.inlinePresentationIntent = .stronglyEmphasized
            }
        }
    }

    func italic() -> AttributedString {
        return then {
            if var inlinePresentationIntent = $0.inlinePresentationIntent {
                var container = AttributeContainer()
                inlinePresentationIntent.insert(.emphasized)
                container.inlinePresentationIntent = inlinePresentationIntent
                let _ = $0.mergeAttributes(container)
            } else {
                $0.inlinePresentationIntent = .emphasized
            }
        }
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
