//
//  OverlayTag.swift
//  InlineImageWithText
//
//  Created by Yang Xu on 2022/8/13.
//

import Foundation
import SwiftUI

struct Demo2: View {
    var body: some View {
        VStack(alignment:.leading,spacing: 50) {
            TitleWithOverlay(title: "佳农 马来西亚冷冻 猫山王浏览果肉 D197", tag: "京东超市", fontStyle: .body)

            TitleWithOverlay(title: "佳农 马来西亚冷冻 猫山王浏览果肉 D197", tag: "京东超市", fontStyle: .body)
                .environment(\.sizeCategory, .extraExtraExtraLarge)
        }
    }
}

struct TitleWithOverlay: View {
    let title: LocalizedStringKey
    let tag: LocalizedStringKey

    @ScaledMetric private var fontSize: CGFloat
    private let pointSize: CGFloat
    private let textStyle: Font.TextStyle
    @State private var tagSize: CGSize = .zero

    @State private var placeHolder = Text("")

    init(title: LocalizedStringKey, tag: LocalizedStringKey, fontStyle: UIFont.TextStyle) {
        self.title = title
        self.tag = tag
        let uiFont = UIFont.preferredFont(forTextStyle: fontStyle)
        pointSize = uiFont.pointSize
        textStyle = Font.TextStyle.convert(from: fontStyle)
        _fontSize = ScaledMetric(wrappedValue: pointSize, relativeTo: textStyle)
    }

    var body: some View {
        VStack {
            placeHolder + Text(" ") + Text(title)
        }
        .font(.custom("", size: pointSize, relativeTo: textStyle))
        .overlay(alignment: .topLeading) {
            TagView(tag: tag, textStyle: textStyle, fontSize: fontSize - 6, horizontalPadding: 5.5, verticalPadding: 2)
                .alignmentGuide(.top, computeValue: { $0[.top] - fontSize / 18 })
                .background(
                    GeometryReader { proxy in
                        Color.clear
                            .task(id:fontSize) {
                                tagSize = proxy.size
                            }
                    }
                )
        }
        .task(id: tagSize, createPlaceHolder)
    }

    @Sendable
    func createPlaceHolder() async {
        let size = CGSize(width: tagSize.width, height: 1)
        let uiImage = await UIImage.solidImageGenerator(.clear, size: size)
        let image = Image(uiImage: uiImage)
        placeHolder = Text(image)
    }
}

struct TagView: View {
    let tag: LocalizedStringKey
    let fontColor: Color
    let backgroundColor: Color
    let fontSize: CGFloat
    let horizontalPadding: CGFloat
    let verticalPadding: CGFloat
    let textStyle: Font.TextStyle

    init(tag: LocalizedStringKey, textStyle: Font.TextStyle, fontColor: Color = .white, backgroundColor: Color = Color("tagColor"), fontSize: CGFloat, horizontalPadding: CGFloat = 3, verticalPadding: CGFloat = 1) {
        self.tag = tag
        self.backgroundColor = backgroundColor
        self.fontSize = fontSize
        self.textStyle = textStyle
        self.fontColor = fontColor
        self.horizontalPadding = horizontalPadding
        self.verticalPadding = verticalPadding
    }

    var cornerRadius: CGFloat {
        fontSize * (3 / 17)
    }

    var body: some View {
        Text(tag)
            .font(.custom("", fixedSize: fontSize))
            .foregroundColor(fontColor)
            .padding(.horizontal, horizontalPadding)
            .padding(.vertical, verticalPadding)
            .background(RoundedRectangle(cornerRadius: cornerRadius).fill(backgroundColor))
    }
}

struct TagViewPreview: PreviewProvider {
    static var previews: some View {
//        TagView(tag: "京东超市", textStyle: .body, fontSize: 15)
        Demo2()
            .frame(width:200)
    }
}

extension UIImage {
    @Sendable
    static func solidImageGenerator(_ color: UIColor, size: CGSize) async -> UIImage {
        let format = UIGraphicsImageRendererFormat()
        let image = UIGraphicsImageRenderer(size: size, format: format).image { rendererContext in
            color.setFill()
            rendererContext.fill(CGRect(origin: .zero, size: size))
        }
        return image
    }
}
