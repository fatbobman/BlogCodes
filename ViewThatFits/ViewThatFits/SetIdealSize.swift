//
//  SetIdealSize.swift
//  ViewThatFits
//
//  Created by Yang Xu on 2023/11/5.
//

import Foundation
import SwiftUI

struct SetIdealSize: View {
    @State var useIdealSize = false
    var body: some View {
        VStack {
            Button("Use Ideal Size") {
                useIdealSize.toggle()
            }
            .buttonStyle(.bordered)

            Rectangle()
                .fill(.orange)
                .frame(width: 100, height: 100)
                .fixedSize(horizontal: useIdealSize ? true : false, vertical: useIdealSize ? true : false)

            Rectangle()
                .fill(.cyan)
                .frame(idealWidth: 100, idealHeight: 100)
                .fixedSize(horizontal: useIdealSize ? true : false, vertical: useIdealSize ? true : false)
            
            Rectangle()
                .fill(.green)
                .fixedSize(horizontal: useIdealSize ? true : false, vertical: useIdealSize ? true : false)
        }
        .animation(.easeInOut, value: useIdealSize)
    }
}

#Preview {
    SetIdealSize()
}
