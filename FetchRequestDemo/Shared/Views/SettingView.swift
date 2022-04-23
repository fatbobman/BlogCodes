//
//  SettingView.swift
//  FetchRequestDemo
//
//  Created by Yang Xu on 2022/4/21
//  Copyright © 2022 Yang Xu. All rights reserved.
//
//  Follow me on Twitter: @fatbobman
//  My Blog: https://www.fatbobman.com
//

import Foundation
import SwiftUI

struct SettingView: View {
    let persistenceController = PersistenceController.shared
    @Environment(\.dismiss) var dismiss
    var body: some View {
        NavigationView {
            List {
                Button("清空数据") { Task { await persistenceController.emptyItem() }}
                Button("添加测试数据") {
                    Task {
                        if persistenceController.itemCount() < 40000 {
                            await persistenceController.emptyItem()
                            await persistenceController.batchInsertItem()
                        }
                    }
                }
            }
            .navigationTitle("设置")
            .toolbar {
                ToolbarItem { Button("取消") { dismiss() }}
            }
        }
    }
}
