import SwiftUI
import UIKit

struct ContentView: View {
    @Environment(\.openURL) var openURL
    @State var url:URL?
    var show:Binding<Bool>{
        Binding<Bool>(get: { url != nil }, set: {_ in url = nil})
    }
    
    let attributedString:AttributedString = {
        var fatbobman = AttributedString("肘子的Swift记事本")
        fatbobman.link = URL(string: "https://www.fatbobman.com")!
        fatbobman.font = .title
        var tel = AttributedString("电话号码")
        tel.link = URL(string:"tel://13900000000")
        tel.backgroundColor = .yellow
        var and = AttributedString(" and ")
        and.foregroundColor = .red
        return fatbobman + and + tel
    }()
    
    var body: some View {
        Form {
            Section("调用 UIApplication"){
                // 直接调用系统方法，不经过 openURL
                Button("Wikipedia"){
                    UIApplication.shared.open(URL(string:"https://www.wikipedia.org")!)
                }
            }
            
            Section("在 Button 中显式调用 openURL"){
                // 调用的是 ContentView 中引入的环境值，不受 Form 外的 openURL 限制
                Button("Wikipedia"){
                    openURL(URL(string: "https://www.wikipedia.org")!)
                }
                
                
                Button(action: {
                    openURL(URL(string: "https://www.wikipedia.org")!)
                }, label: {
                    Circle().fill(.angularGradient(.init(colors: [.red,.orange,.pink]), center: .center, startAngle: .degrees(0), endAngle: .degrees(360)))
                })
            }
            
            Section("Link "){
                Link(destination: URL(string: "https://www.wikipedia.org")!, label: {
                    Image(systemName: "globe")
                    Text("Wikipedia")
                })
                
                Link("Wikipedia 被屏蔽", destination: URL(string: "https://www.wikipedia.org")!)
                    .tint(.pink)
                    .environment(\.openURL,.init(handler:{ _ in
                        return .discarded // 相当于屏蔽了当前的开启链接行为
                    }))
            }
            
            Section("Text 对 LocalizedStringKey 自动识别"){
                // 只有使用类型为 LocalizedStringKey 的构造器，才能自动转换 url
                Text("www.wikipedia.org 13900000000 feedback@fatbobman.com")
                    .tint(.green)
            }
            
            Section("Text 解析 LocalizedStringKey 中的 markdown 标记"){
                // markdown 解析
                Text("[Wikipedia](https://www.wikipedia.org) [13900000000](tel://13900000000)")
            }
            
            Section("AttributedString") {
                Text(attributedString)
            }
            
            Section("NSDataDetector + AttributedString"){
                // 使用 NSDataDetector 进行转换
                Text("https://www.wikipedia.org 13900000000 feedback@fatbobman.com".toDetectedAttributedString())
            }
        }
        .environment(\.openURL, .init(handler: { url in
            switch url.scheme {
            case "tel","http","https","mailto":
                self.url = url
                return .handled
            default:
                return .systemAction
            }
        }))
        .confirmationDialog("", isPresented: show){
            if let url = url {
                Button("复制到剪贴板"){
                    let str:String
                    switch url.scheme {
                    case "tel":
                        str = url.absoluteString.replacingOccurrences(of: "tel://", with: "")
                    default:
                        str = url.absoluteString
                    }
                    UIPasteboard.general.string = str
                }
                Button("打开URL"){openURL(url)}
            }
        }
        .tint(.cyan)
    }
}




