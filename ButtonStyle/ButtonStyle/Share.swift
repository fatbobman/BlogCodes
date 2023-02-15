//
//  ButtonView.swift
//  ButtonStyle
//
//  Created by Yang Xu on 2023/2/15.
//

import Foundation
import SwiftUI

struct ButtonView<V>: View where V: View {
    let label: V
    let action: () -> Void
    init(label: V, action: @escaping () -> Void) {
        self.label = label
        self.action = action
    }

    var body: some View {
        Button {
            action()
        } label: {
            label
                .foregroundColor(.white)
                .padding(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundColor(.blue)
                )
                .compositingGroup()
                .shadow(radius: 5, x: 0, y: 3)
                .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}

struct ButtonModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundColor(.white)
            .padding(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .foregroundColor(.blue)
            )
            .shadow(radius: 5, x: 0, y: 3)
            .contentShape(Rectangle())
            .buttonStyle(.plain)
    }
}

struct RoundedAndShadowButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(.white)
            .padding(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .foregroundColor(.blue)
            )
            .compositingGroup()
            .shadow(radius: configuration.isPressed ? 0 : 5, x: 0, y: configuration.isPressed ? 0 : 3)
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
            .animation(.spring(), value: configuration.isPressed)
    }
}

extension ButtonStyle where Self == RoundedAndShadowButtonStyle {
    static var roundedAndShadow: RoundedAndShadowButtonStyle {
        RoundedAndShadowButtonStyle()
    }
}

struct RoundedAndShadowProButtonStyle: ButtonStyle {
    @Environment(\.controlSize) var controlSize
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(.white)
            .padding(getPadding())
            .font(getFontSize())
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .foregroundColor(configuration.role == .destructive ? .red : .blue)
            )
            .compositingGroup()
            .overlay(
                VStack {
                    if configuration.isPressed {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.white.opacity(0.5))
                            .blendMode(.hue)
                    }
                }
            )
            .shadow(radius: configuration.isPressed ? 0 : 5, x: 0, y: configuration.isPressed ? 0 : 3)
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
            .animation(.spring(), value: configuration.isPressed)
    }

    func getPadding() -> EdgeInsets {
        let unit: CGFloat = 4
        switch controlSize {
        case .regular:
            return EdgeInsets(top: unit * 2, leading: unit * 4, bottom: unit * 2, trailing: unit * 4)
        case .large:
            return EdgeInsets(top: unit * 3, leading: unit * 5, bottom: unit * 3, trailing: unit * 5)
        case .mini:
            return EdgeInsets(top: unit / 2, leading: unit * 2, bottom: unit / 2, trailing: unit * 2)
        case .small:
            return EdgeInsets(top: unit, leading: unit * 3, bottom: unit, trailing: unit * 3)
        @unknown default:
            fatalError()
        }
    }

    func getFontSize() -> Font {
        switch controlSize {
        case .regular:
            return .body
        case .large:
            return .title3
        case .small:
            return .callout
        case .mini:
            return .caption2
        @unknown default:
            fatalError()
        }
    }
}

extension ButtonStyle where Self == RoundedAndShadowProButtonStyle {
    static var roundedAndShadowPro: RoundedAndShadowProButtonStyle {
        RoundedAndShadowProButtonStyle()
    }
}

struct CancellableButtonStyle: PrimitiveButtonStyle {
    @GestureState var isPressing = false

    func makeBody(configuration: Configuration) -> some View {
        let drag = DragGesture(minimumDistance: 0)
            .updating($isPressing, body: { _, pressing, _ in
                if !pressing { pressing = true }
            })

        configuration.label
            .foregroundColor(.white)
            .padding(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .foregroundColor(configuration.role == .destructive ? .red : .blue)
            )
            .compositingGroup()
            .shadow(radius: isPressing ? 0 : 5, x: 0, y: isPressing ? 0 : 3)
            .scaleEffect(isPressing ? 0.95 : 1)
            .animation(.spring(), value: isPressing)
            .gesture(drag)
            .simultaneousGesture(TapGesture().onEnded {
                configuration.trigger()
            })
    }
}

extension PrimitiveButtonStyle where Self == CancellableButtonStyle {
    static var cancellable: CancellableButtonStyle {
        CancellableButtonStyle()
    }
}

struct TriggerActionStyle: ButtonStyle {
    let trigger: () -> Void
    init(trigger: @escaping () -> Void) {
        self.trigger = trigger
    }

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(.white)
            .padding(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .foregroundColor(.blue)
            )
            .compositingGroup()
            .shadow(radius: configuration.isPressed ? 0 : 5, x: 0, y: configuration.isPressed ? 0 : 3)
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
            .animation(.spring(), value: configuration.isPressed)
            .onChange(of: configuration.isPressed) { isPressed in
                if !isPressed {
                    DispatchQueue.main.async {
                        trigger()
                    }
                }
            }
    }
}

extension ButtonStyle where Self == TriggerActionStyle {
    static func triggerAction(trigger perform: @escaping () -> Void) -> TriggerActionStyle {
        .init(trigger: perform)
    }
}

struct TriggerButton2: PrimitiveButtonStyle {
    var trigger: () -> Void

    func makeBody(configuration: PrimitiveButtonStyle.Configuration) -> some View {
        MyButton(trigger: trigger, configuration: configuration)
    }

    struct MyButton: View {
        @State private var pressed = false
        var trigger: () -> Void

        let configuration: PrimitiveButtonStyle.Configuration

        var body: some View {
            return configuration.label
                .foregroundColor(.white)
                .padding(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundColor(.blue)
                )
                .compositingGroup()
                .shadow(radius: pressed ? 0 : 5, x: 0, y: pressed ? 0 : 3)
                .scaleEffect(pressed ? 0.95 : 1)
                .animation(.spring(), value: pressed)
                .onLongPressGesture(minimumDuration: 2.5, maximumDistance: .infinity, pressing: { pressing in
                    withAnimation(.easeInOut(duration: 0.3)) {
                        self.pressed = pressing
                    }
                    if pressing {
                        configuration.trigger() // 原来的 action
                        trigger() // 新增的 action
                    } else {
                        print("release")
                    }
                }, perform: {})
        }
    }
}
