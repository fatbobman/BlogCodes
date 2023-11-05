//
//  TextDemo.swift
//  ViewThatFits
//
//  Created by Yang Xu on 2023/11/5.
//

import Foundation
import SwiftUI

struct TextDemo: View {
    @State var width: CGFloat = 100
    var body: some View {
        VStack {
            Slider(value: $width, in: 30 ... 300)
                .padding()
            ViewThatFits {
                Text("Fatbobman's Swift Weekly")
                Text("Fatbobman's Weekly")
                Text("Fat's Weekly")
                Text("Weekly")
                    .fixedSize()
            }
            .frame(width: width)
            .border(.red)
        }
    }
}

struct TextDemo1: View {
    @State var width: CGFloat = 100
    var body: some View {
        VStack {
            Slider(value: $width, in: 30 ... 300)
                .padding()
            ViewThatFits {
                Text("Fatbobman's Swift Weekly")
                    .font(.body)
                Text("Fatbobman's Swift Weekly")
                    .font(.subheadline)
                Text("Fatbobman's Swift Weekly")
                    .font(.footnote)
                Text("Fatbobman's Swift Weekly")
                    .font(.caption)
                    .fixedSize()
            }
            .frame(width: width)
            .border(.red)
        }
    }
}

struct TextDemo2: View {
    @State var width: CGFloat = 100
    var body: some View {
        VStack {
            Slider(value: $width, in: 30 ... 300)
                .padding()

            Text("Fatbobman's Swift Weekly")
                .lineLimit(1)
                .font(.body)
                .minimumScaleFactor(0.3)
                .frame(width: width)
                .border(.red)
        }
    }
}

#Preview {
    TextDemo2()
}

