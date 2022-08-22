//
//  Transcription.swift
//  ShowKeywordsInText
//
//  Created by Yang Xu on 2022/8/18.
//

import Foundation

struct Transcription: Equatable, Identifiable {
    let id = UUID()
    let startTime: String
    var context: String
}

struct TranscriptionRange {
    let position: Int
    let range: Range<String.Index>
}

struct KeywordsResult {
    let currentPosition: Int?
    let transcriptionRanges: [TranscriptionRange]
}

let sampleSentence:[String] = [
    "在 SwiftUI 中，尺寸这一布局中极为重要的概念，似乎变得有些神秘。无论是设置尺寸还是获取尺寸都不是那么地符合直觉。",
    "本文将从布局的角度入手，为你揭开盖在 SwiftUI 尺寸概念上面纱，了解并掌握 SwiftUI 中众多尺寸的含义与用法；",
    "并通过创建符合 Layout 协议的 frame 和 fixedSize 视图修饰器的复制品，让你对 SwiftUI 的布局机制有更加深入地理解。",
    "SwiftUI 是一个声明式框架，提供了强大的自动布局能力。开发者几乎可以在不涉及尺寸（ 或很少涉及 ）这一概念的情况下创建出漂亮、精美、准确的布局效果。",
    "但由于 SwiftUI 的视图并没有提供尺寸这一属性，因此即使在 SwiftUI 诞生了数年后的今天，如何获取视图的尺寸仍然是网络上的热门问题。",
    "同时对于不少的开发者来说，使用 frame 修饰器为视图设置尺寸产生的结果也经常与他们的预期有所不同。",
    "这并非意味着尺寸在 SwiftUI 中不重要，事实恰恰相反，正是由于在 SwiftUI 中尺寸是一个十分复杂的概念，苹果将绝大多数有关尺寸的配置和表述都隐藏到了引擎盖之下，刻意对其进行了包装与淡化。",
    "淡化尺寸概念的初衷或许是出于以下两点：",
    "引导开发者转型到声明式编程逻辑，转变使用精准尺寸的习惯",
    "掩盖 SwiftUI 中复杂的尺寸概念，减少初学者的困扰",
    "但无论如何淡化或掩盖，当涉及更加高级、复杂、精准的布局时，尺寸是一个始终无法绕开的环节。随着你对 SwiftUI 认识的提高，了解并掌握 SwiftUI 中的众多尺寸含义也势在必行。",
    "From the first day of the SwiftUI framework, we have primary layout containers like VStack, HStack, and ZStack.",
    "The current iteration of the SwiftUI framework brings another layout container allowing us to place views in a grid. But the most important addition was the Layout protocol that all layout containers conform to. ",
    "It also allows us to build our super-custom layout containers from scratch. This week we will learn the basics of the Layout protocol in SwiftUI and how to build conditional layouts using AnyLayout type.",
    "You might be familiar with the LazyVGrid and LazyHGrid views we have from the second iteration of the SwiftUI framework.",
    "They work great for the massive data arrays you want to display as the grid. But it is not always possible to arrange the columns and rows strictly because of their lazy nature.",
    "View transitions are available from the very first version of the SwiftUI framework. ",
    "The framework can apply a particular transition whenever the view is removed or added to the view hierarchy. The latest iteration of the SwiftUI framework brings us a new type of transition called content transitions. It allows us to apply a particular transition to the content of the view whenever it changes. ",
    "This week we will learn how to use the new API to apply content transition in SwiftUI.",
]
