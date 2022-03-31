import Foundation
import SwiftUI

@resultBuilder
public enum AttributedTextBuilder {
    public static func buildBlock() -> AttributedString {
        AttributedString("")
    }

    public static func buildBlock(_ components: AttributedText...) -> AttributedString {
        let result = components.map { $0.content }.reduce(into: AttributedString("")) { result, next in
            result.append(next)
        }
        return result.content
    }

    public static func buildExpression(_ attributedString: AttributedText) -> AttributedString {
        attributedString.content
    }

    public static func buildExpression(_ string: String) -> AttributedString {
        AttributedString(string)
    }

    public static func buildOptional(_ component: AttributedText?) -> AttributedString {
        component?.content ?? .init("")
    }

    public static func buildEither(first component: AttributedText) -> AttributedString {
        component.content
    }

    public static func buildEither(second component: AttributedText) -> AttributedString {
        component.content
    }

    public static func buildArray(_ components: [AttributedText]) -> AttributedString {
        let result = components.map { $0.content }.reduce(into: AttributedString("")) { result, next in
            result.append(next)
        }
        return result.content
    }

    public static func buildLimitedAvailability(_ component: AttributedText) -> AttributedString {
        .init("")
    }
}
