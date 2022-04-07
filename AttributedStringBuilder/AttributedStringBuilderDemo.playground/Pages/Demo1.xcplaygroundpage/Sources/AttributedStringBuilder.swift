import Foundation
import SwiftUI

@resultBuilder
public enum AttributedStringBuilder {
    public static func buildBlock() -> AttributedString {
        .init("")
    }

    public static func buildBlock(_ components: AttributedString...) -> AttributedString {
        components.reduce(into: AttributedString("")) { result, next in
            result.append(next)
        }
    }

    public static func buildExpression(_ attributedString: AttributedString) -> AttributedString {
        attributedString
    }

    public static func buildExpression(_ string: String) -> AttributedString {
        AttributedString(string)
    }

    public static func buildOptional(_ component: AttributedString?) -> AttributedString {
        component ?? .init("")
    }

    public static func buildEither(first component: AttributedString) -> AttributedString {
        component
    }

    public static func buildEither(second component: AttributedString) -> AttributedString {
        component
    }

    public static func buildArray(_ components: [AttributedString]) -> AttributedString {
        components.reduce(into: AttributedString("")) { result, next in
            result.append(next)
        }
    }

    public static func buildLimitedAvailability(_ component: AttributedString) -> AttributedString {
        component
    }

    public static func buildFinalResult(_ component: AttributedString) -> Text {
        Text(component)
    }
}
