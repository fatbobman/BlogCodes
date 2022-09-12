//
//  Fouced.swift
//  Centering
//
//  Created by Yang Xu on 2022/8/29.
//

import Foundation
import SwiftUI

struct FocusedView:View{
    @State var text = ""
    @FocusState var focused:Bool
    var body: some View{
        Form{
            TextField("name:",text: $text)
                .focused($focused)
                .onSubmit {
                    focused = true
                }
        }
    }

}
