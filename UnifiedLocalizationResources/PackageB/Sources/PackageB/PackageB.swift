import I18NResource
import SwiftUI

public struct ViewB: View {
    public init() {}
    public var body: some View {
        Text("ViewB", bundle: .i18n)
            .foregroundColor(Color("i18nColor",bundle: .i18n))
    }
}

struct ViewBPreview: PreviewProvider {
    static var previews: some View {
        VStack {
            ViewB()
            ViewB()
                .environment(\.locale, .init(identifier: "zh-cn"))
        }
    }
}
