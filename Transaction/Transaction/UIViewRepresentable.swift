//
//  UIView.swift
//  Transaction
//
//  Created by Yang Xu on 2023/6/26.
//

import SwiftUI

struct MyView:UIViewRepresentable {
    @Binding var isActive:Bool
    func makeUIView(context: Context) -> some UIView {
        return UIView()
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        let transaction = context.transaction
        // check animation
        // do something
    }
}
