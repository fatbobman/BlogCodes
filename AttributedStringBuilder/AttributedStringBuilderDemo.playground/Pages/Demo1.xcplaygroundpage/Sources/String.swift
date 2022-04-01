import Foundation
import SwiftUI

public extension String {
    func color(_ color: Color) -> AttributedString {
        AttributedString(self)
            .color(color)
    }

    func bold() -> AttributedString {
        AttributedString(self)
            .bold()
    }

    func italic() -> AttributedString {
        AttributedString(self)
            .italic()
    }

    func localized() -> AttributedString {
        .init(localized: LocalizationValue(self))
    }
}
