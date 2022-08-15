//
//  ImageInText.swift
//  InlineImageWithText
//
//  Created by Yang Xu on 2022/8/13.
//

import Foundation
import SwiftUI

struct Demo1: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 50) {
            TitleWithImage(title: "佳农 马来西亚冷冻 猫山王浏览果肉 D197", fontStyle: .body, tagName: "JD_Tag")

            TitleWithImage(title: "佳农 马来西亚冷冻 猫山王浏览果肉 D197", fontStyle: .body, tagName: "JD_Tag")
                .environment(\.sizeCategory, .extraExtraExtraLarge)
        }
    }
}

struct TitleWithImage: View {
    let title: LocalizedStringKey
    let tagName: String

    @ScaledMetric private var fontSize: CGFloat
    @State var tagImage = Image(systemName: "ant.fill") // 􀌛
    private let baselineOffset: CGFloat
    private let pointSize: CGFloat
    private let textStyle: Font.TextStyle

    init(title: LocalizedStringKey, fontStyle: UIFont.TextStyle, tagName: String, baselineOffset: CGFloat? = nil) {
        self.title = title
        self.tagName = tagName
        let uiFont = UIFont.preferredFont(forTextStyle: fontStyle)
        pointSize = uiFont.pointSize
        textStyle = Font.TextStyle.convert(from: fontStyle)
        _fontSize = ScaledMetric(wrappedValue: pointSize, relativeTo: textStyle)
        self.baselineOffset = baselineOffset ?? (-pointSize / 7)
    }

    var body: some View {
        VStack {
            let tag = Text(tagImage).baselineOffset(baselineOffset)
            let spacer = Text(" ")
            let label = Text(title)
            tag + spacer + label
        }
        .font(.custom("", size: pointSize, relativeTo: textStyle))
        .task(id: fontSize, sizeImage)
    }

    @Sendable
    func sizeImage() async {
        if var image = UIImage(named: tagName) {
            let aspectRatio = image.size.width / image.size.height
            let newSize = CGSize(width: aspectRatio * fontSize, height: fontSize)
            image = image.resized(to: newSize)
            tagImage = Image(uiImage: image)
        }
    }
}

extension UIImage {
    func resized(to size: CGSize) -> UIImage {
        return UIGraphicsImageRenderer(size: size).image { _ in
            draw(in: CGRect(origin: .zero, size: size))
        }
    }
}

extension Font.TextStyle {
    static func convert(from style: UIFont.TextStyle) -> Self {
        switch style {
        case .body:
            return .body
        case .callout:
            return .callout
        case .caption1:
            return .caption
        case .caption2:
            return .caption2
        case .footnote:
            return .footnote
        case .headline:
            return .headline
        case .subheadline:
            return .subheadline
        case .largeTitle:
            return .largeTitle
        case .title1:
            return .title
        case .title2:
            return .title2
        case .title3:
            return .title3
        default:
            return .body
        }
    }
}

struct Demo1_Preview: PreviewProvider {
    static var previews: some View {
        Demo1()
            .frame(width: 200)
    }
}
