//
//  CellView.swift
//  NewFeaturesOfScrollView
//
//  Created by Yang Xu on 2023/6/12.
//

import SwiftUI

struct CellView: View {
    let width: CGFloat?
    let height: CGFloat?
    let color: Color
    let debugInfo:String?

    init(width: CGFloat? = 100, height: CGFloat? = 100, color: Color = .cyan,debugInfo:String? = nil) {
        self.width = width
        self.height = height
        self.color = color
        self.debugInfo = debugInfo
        if let debugInfo {
            print("cellView init \(debugInfo)")
        }
    }

    var body: some View {
        if let debugInfo {
            let _ = print("update \(debugInfo)")
        }
        RoundedRectangle(cornerRadius: 10)
            .foregroundStyle(color.gradient)
            .frame(width: width, height: height)
    }
}

#Preview {
    CellView()
}
