//
//  MockContainer.swift
//  Layout_In_SwiftUI
//
//  Created by Yang Xu on 2022/7/8.
//

import Foundation
import SwiftUI

struct MockContainer:Layout {
    let label:String
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        print("\(label) get proposal:",proposal)
        guard subviews.count == 1,let subview = subviews.first else {fatalError()}
        
        let size = subview.sizeThatFits(proposal)
        print("\(label)'s need size is \(size)")
        return size
    }
    
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        print("\(label) place sub views at ",bounds)
    }
}
