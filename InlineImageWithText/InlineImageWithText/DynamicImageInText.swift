//
//  DynamicImageInText.swift
//  InlineImageWithText
//
//  Created by Yang Xu on 2022/8/13.
//

import Foundation
import SwiftUI


struct Demo3:View{
    var body: some View{
        VStack(alignment: .leading, spacing: 50) {
            TitleWithDynamicImage(title: "佳农 马来西亚冷冻 猫山王浏览果肉 D197", tag: "京东超市", fontStyle: .body)

            TitleWithDynamicImage(title: "佳农 马来西亚冷冻 猫山王浏览果肉 D197", tag: "京东超市", fontStyle: .body)
                .environment(\.sizeCategory, .extraExtraExtraLarge)
        }
    }
}

struct TitleWithDynamicImage: View {
    let title: LocalizedStringKey
    let tag: LocalizedStringKey

    @ScaledMetric private var fontSize: CGFloat
    @State var tagImage = Image(systemName: "ant.fill") // 􀌛
    private let baselineOffset: CGFloat
    private let pointSize: CGFloat
    private let textStyle: Font.TextStyle

    init(title: LocalizedStringKey, tag: LocalizedStringKey,fontStyle: UIFont.TextStyle,  baselineOffset: CGFloat? = nil) {
        self.title = title
        self.tag = tag
        let uiFont = UIFont.preferredFont(forTextStyle: fontStyle)
        pointSize = uiFont.pointSize
        textStyle = Font.TextStyle.convert(from: fontStyle)
        _fontSize = ScaledMetric(wrappedValue: pointSize, relativeTo: textStyle)
        self.baselineOffset = baselineOffset ?? (-pointSize / 7)
    }

    var body: some View{
        VStack {
            let tag = Text(tagImage).baselineOffset(baselineOffset)
            let spacer = Text(" ")
            let label = Text(title)
            tag + spacer + label
        }
        .font(.custom("", size: pointSize, relativeTo: textStyle))
        .task(id: fontSize, createImage)
    }

    @Sendable
    func createImage() async {
        let tagView = TagView(tag: tag, textStyle: textStyle, fontSize: fontSize - 6, horizontalPadding: 5.5, verticalPadding: 2)
        tagView.generateSnapshot(snapshot: $tagImage)
    }
}

extension View {
    func generateSnapshot(snapshot: Binding<Image>) {
        Task {
            let renderer = await ImageRenderer(
                content: self)
            await MainActor.run {
                renderer.scale = UIScreen.main.scale
            }
            if let image = await renderer.uiImage {
                snapshot.wrappedValue = Image(uiImage: image)
            }
        }
    }
}

struct Demo3_Preview:PreviewProvider{
    static var previews: some View{
        Demo3()
            .frame(width:200)
    }
}
