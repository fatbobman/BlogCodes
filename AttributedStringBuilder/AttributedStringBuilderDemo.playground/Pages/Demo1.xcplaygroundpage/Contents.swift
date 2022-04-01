import Cocoa
import Foundation
import PlaygroundSupport
import SwiftUI

struct DemoView: View {
    @State var gender: Gender = .female

    @AttributedStringBuilder
    var text: Text {
        "~_Hello_~"
            .localized()
            .color(.green)

        if case .male = gender {
            " Boy!"
                .color(.blue)
                .bold()

        } else {
            " Girl!"
                .color(.pink)
                .bold()
                .italic()
        }

        let count = 5
        for i in 0..<count {
            " \(i) "
        }

        if #available(macOS 13.0, iOS 16.0, *) {
            AttributedString("Hello macOS 13")
                .futureMethod()
        } else {
            AttributedString("Hi Monterey")
                .color(.brown)
        }
    }

    var body: some View {
        VStack {
            Picker("", selection: $gender) {
                Text("男孩")
                    .tag(Gender.male)
                Text("女孩")
                    .tag(Gender.female)
            }
            .pickerStyle(.segmented)
            text
        }
        .frame(width: 150, height: 100)
    }
}

enum Gender {
    case male, female
}

PlaygroundPage.current.setLiveView(DemoView())

@AttributedStringBuilder
var text: Text {
    "Hello world"
}

var text1: Text {
    let _a = AttributedStringBuilder.buildExpression("Hello world")
    let _blockResult = AttributedStringBuilder.buildBlock(_a)
    return AttributedStringBuilder.buildFinalResult(_blockResult)
}

text1
