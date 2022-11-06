import I18NResource
import SwiftUI

public struct ViewA: View {
    public init() {}
    public var body: some View {
        Text("HELLO_WORLD", bundle: .i18n)
            .font(.title)
            .foregroundColor(Color("i18nColor", bundle: .i18n))
    }
}

struct ViewAPreview: PreviewProvider {
    static var previews: some View {
        VStack {
            ViewA()
            ViewA()
                .environment(\.locale, .init(identifier: "zh-cn"))
            VStack {
                ViewA()
                ViewA()
                    .environment(\.locale, .init(identifier: "zh-cn"))
            }
            .environment(\.colorScheme, .dark)
        }
    }
}
