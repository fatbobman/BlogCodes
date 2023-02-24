//
//  ContentView.swift
//  LayoutInTheSwiftUIWay
//
//  Created by Yang Xu on 2023/2/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            List {
                NavigationLink("Offset", destination: { OffsetDemo() })
                NavigationLink("Alignment", destination: { AlignmentDemo() })
                NavigationLink("NameSpace", destination: { NameSpaceDemo() })
                NavigationLink("Alignment without GeometryReader", destination: { AlignmentWithoutGeometryReader() })
                NavigationLink("Transition", destination: { TransitionDemo() })
            }
            .navigationTitle("Layout Demo")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
