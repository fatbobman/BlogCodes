//
//  Feature.swift
//  NewFeaturesOfScrollView
//
//  Created by Yang Xu on 2023/6/12.
//

import SwiftUI

enum Features:String,Identifiable,Hashable {
    case contentMarginsForScrollView = "contentMargins ScrollView Content"
    case contentMarginsForScrollIndicator = "contentMargins ScrollIndicator"
    case contentMarginsForTextEditor = "contentMargins TextEditor"
    
    var id:Features{
        self
    }
}
