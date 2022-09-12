//
//  ScrollStatusByIntrospect.swift
//  ScrollStatus
//
//  Created by Yang Xu on 2022/9/11.
//

import Foundation
import Introspect
import IsScrolling
import SwiftUI

struct ScrollStatusByIntrospect: View {
    @State var isScrolling1 = false
    @State var isScrolling2 = false
    var body: some View {
        VStack {
            Text("isScrolling: \(isScrolling1 ? "True" : "False")")
            List {
                ForEach(0..<100) { i in
                    Text("id:\(i)")
                }
            }
            .scrollStatusByIntrospect(isScrolling: $isScrolling1)
            Text("isScrolling: \(isScrolling2 ? "True" : "False")")
            List {
                ForEach(0..<100) { i in
                    Text("id:\(i)")
                        .scrollSensor()
                }
            }
            .scrollStatusMonitor($isScrolling2, monitorMode: .common)
        }
    }
}

final class ScrollDelegate: NSObject, UITableViewDelegate, UIScrollViewDelegate {
    var isScrolling: Binding<Bool>?

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if let isScrolling = isScrolling?.wrappedValue,!isScrolling {
            self.isScrolling?.wrappedValue = true
        }
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if let isScrolling = isScrolling?.wrappedValue, isScrolling {
            self.isScrolling?.wrappedValue = false
        }
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            if let isScrolling = isScrolling?.wrappedValue, isScrolling {
                self.isScrolling?.wrappedValue = false
            }
        }
    }
}

extension View {
    func scrollStatusByIntrospect(isScrolling: Binding<Bool>) -> some View {
        modifier(ScrollStatusByIntrospectModifier(isScrolling: isScrolling))
    }
}

struct ScrollStatusByIntrospectModifier: ViewModifier {
    @State var delegate = ScrollDelegate()
    @Binding var isScrolling: Bool
    func body(content: Content) -> some View {
        content
            .onAppear {
                self.delegate.isScrolling = $isScrolling
            }
            .introspectScrollView { scrollView in
                scrollView.delegate = delegate
            }
            .introspectTableView { tableView in
                tableView.delegate = delegate
            }
    }
}
