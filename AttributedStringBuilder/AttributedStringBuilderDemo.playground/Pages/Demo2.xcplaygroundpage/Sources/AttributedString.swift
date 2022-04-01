import Foundation
import SwiftUI

public extension AttributedString {
    func color(_ color: Color) -> AttributedString {
        var container = AttributeContainer()
        container.foregroundColor = color
        return then {
            for run in $0.runs {
                $0[run.range].mergeAttributes(container, mergePolicy: .keepCurrent)
            }
        }
    }

    func bold() -> AttributedString {
        return then {
            for run in $0.runs {
                if var inlinePresentationIntent = run.inlinePresentationIntent {
                    var container = AttributeContainer()
                    inlinePresentationIntent.insert(.stronglyEmphasized)
                    container.inlinePresentationIntent = inlinePresentationIntent
                    let _ = $0[run.range].mergeAttributes(container)
                } else {
                    $0[run.range].inlinePresentationIntent = .stronglyEmphasized
                }
            }
        }
    }

    func italic() -> AttributedString {
        return then {
            for run in $0.runs {
                if var inlinePresentationIntent = run.inlinePresentationIntent {
                    var container = AttributeContainer()
                    inlinePresentationIntent.insert(.emphasized)
                    container.inlinePresentationIntent = inlinePresentationIntent
                    let _ = $0[run.range].mergeAttributes(container)
                } else {
                    $0[run.range].inlinePresentationIntent = .emphasized
                }
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
