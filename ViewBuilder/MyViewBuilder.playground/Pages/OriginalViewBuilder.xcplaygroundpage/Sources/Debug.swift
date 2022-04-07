import Foundation
import SwiftUI

public extension View {
    @ViewBuilder
    func debug() -> some View {
        let _ = print(Mirror(reflecting: self).subjectType)
        self
    }

    @ViewBuilder
    func dump() -> some View {
        let _ = print(self)
        self
    }
}
