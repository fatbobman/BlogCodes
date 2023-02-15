//
//  ContentView.swift
//  ButtonStyle
//
//  Created by Yang Xu on 2023/2/15.
//

import SwiftUI

struct ContentView: View {
    @State var alertMessage: Message?
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 15) {
                    Group {
                        Button(action: { pressAction("borderless") }, label: { label })
                            .buttonStyle(.borderless)
                            .withTitle("borderless")
                        Button(action: { pressAction("borderedProminent") }, label: { label })
                            .buttonStyle(.borderedProminent)
                            .withTitle("bordered Prominent")
                        Button(action: { pressAction("bordered") }, label: { label })
                            .buttonStyle(.bordered)
                            .withTitle("bordered")
                        Button(action: { pressAction("plain") }, label: { label })
                            .buttonStyle(.plain)
                            .withTitle("plain")
                    }
                    Group {
                        ButtonView(label: label, action: { print("button view") })
                            .withTitle("button view")
                        label
                            .modifier(ButtonModifier())
                            .onTapGesture(perform: { pressAction("tap") })
                            .withTitle("tap Gesture")
                        Button(action: { pressAction("button modifier") }, label: { label.modifier(ButtonModifier()) })
                            .withTitle("button modifier")
                    }
                    Group {
                        Button(action: { pressAction("rounded and shadow") }, label: { label })
                            .buttonStyle(.roundedAndShadow)
                            .withTitle("rounded and shadow")
                        Button(action: { pressAction("rounded and shadow pro") }, label: { label })
                            .buttonStyle(.roundedAndShadowPro)
                            .withTitle("rounded and shadow pro")
                        Button(role: .destructive, action: { pressAction("rounded and shadow pro") }, label: { label })
                            .buttonStyle(.roundedAndShadowPro)
                            .withTitle("rounded and shadow pro destructive")
                        Button(action: { pressAction("rounded and shadow pro") }, label: { label })
                            .buttonStyle(.roundedAndShadowPro)
                            .controlSize(.large)
                            .withTitle("rounded and shadow pro Large")
                        Button(action: { pressAction("Cancellable") }, label: { label })
                            .buttonStyle(.cancellable)
                            .withTitle("Cancellable")
                    }
                    Group {
                        NavigationLink(destination: Text("Demo"), label: { label })
                            .withTitle("navigation link with trigger")
                            .buttonStyle(.triggerAction {
                                print("link pressed")
                            })
                        ShareLink(item: URL(string: "https://www.fatbobman.com")!)
                            .buttonStyle(.triggerAction {
                                print("share pressed")
                            })
                            .withTitle("Share with trigger")
                        EditButton()
                            .buttonStyle(.roundedAndShadowPro)
                            .simultaneousGesture(TapGesture().onEnded{ print("pressed")})
                            .withTitle("edit button with simultaneous trigger")
                    }
                }
                .padding(.horizontal, 40)
                .navigationBarTitle("Button Style Demo")
            }
        }
        .alert(item: $alertMessage, content: { message in
            Alert(title: Text(message.text))
        })
    }

    func pressAction(_ text: String) {
//        alertMessage = Message(text: text)
        print(text)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

let label = Label("Press Me", systemImage: "digitalcrown.horizontal.press.fill")

extension View {
    func withTitle(_ title: String) -> some View {
        HStack {
            Text(title.capitalized)
                .font(.caption)
                .frame(width: 150, alignment: .leading)
            self
        }
        .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
    }
}

struct Message: Identifiable {
    let id = UUID()
    let text: String
}
