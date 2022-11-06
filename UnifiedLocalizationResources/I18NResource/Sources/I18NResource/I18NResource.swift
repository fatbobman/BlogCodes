import Foundation

private class BundleFinder {}

public extension Foundation.Bundle {
    static let i18n: Bundle = {
        let bundleName = "I18NResource_I18NResource"
        let bundleResourceURL = Bundle(for: BundleFinder.self).resourceURL
        let candidates = [
            Bundle.main.resourceURL,
            bundleResourceURL,
            Bundle.main.bundleURL,
            bundleResourceURL?.deletingLastPathComponent().deletingLastPathComponent().deletingLastPathComponent(),
            bundleResourceURL?.deletingLastPathComponent().deletingLastPathComponent(),
            bundleResourceURL?.deletingLastPathComponent()
        ]

        for candidate in candidates {
            let bundlePath = candidate?.appendingPathComponent(bundleName + ".bundle")
            if let bundle = bundlePath.flatMap(Bundle.init(url:)) {
                return bundle
            }
        }
        fatalError("unable to find bundle named \(bundleName)")
    }()
}
