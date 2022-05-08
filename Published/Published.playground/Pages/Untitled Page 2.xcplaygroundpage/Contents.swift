import Cocoa
import Combine
import Foundation
import SwiftUI

class T:ObservableObject{
    @SceneStorage("name") var name = "fat"
//    var c:AnyCancellable?

}

//let t = T()
//
//let a = t.objectWillChange.sink(receiveValue:{
//    print($0,"changed")
//})

//t.name = "bobman"

struct TestView:View{
    @StateObject var t = T()
    var body: some View{
        VStack{
            let _ = print(t.name)
            Text(t.name)
            Button("asd"){
                t.name = String(Int.random(in: 0...100))
            }
        }
    }
}

import PlaygroundSupport

PlaygroundPage.current.setLiveView(TestView())
