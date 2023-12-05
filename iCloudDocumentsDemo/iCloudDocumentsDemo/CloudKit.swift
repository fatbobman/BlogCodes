//
//  CloudKit.swift
//  iCloudDocumentsDemo
//
//  Created by Yang Xu on 2023/12/5.
//

import Foundation

func checkiCloudStorage1() {
    // 获取当前iCloud容量
    let fileManager = FileManager.default
    if let currentiCloudToken = fileManager.ubiquityIdentityToken {
        print("iCloud Accessible \(currentiCloudToken)")

        // 使用URLForResourceValues方法获取iCloud的容量信息
        if let iCloudContainerURL = fileManager.url(forUbiquityContainerIdentifier: nil) {
            do {
                let values = try iCloudContainerURL.resourceValues(forKeys: [.volumeAvailableCapacityForImportantUsageKey, .volumeTotalCapacityKey])

                if let availableCapacity = values.volumeAvailableCapacityForImportantUsage,
                   let totalCapacity = values.volumeTotalCapacity
                {
                    print("Total iCloud capacity: \(totalCapacity) bytes")
                    print("Available iCloud capacity: \(availableCapacity) bytes")

                    // 根据需要处理空间不足的情况
                    if availableCapacity <= 0 {
                        print("iCloud storage is full")
                        // 这里可以添加代码来处理存储空间已满的情况
                    }
                }
            } catch {
                print("Error retrieving iCloud storage information: \(error)")
            }
        }
    } else {
        print("No iCloud Access")
        // 这里可以添加代码来处理无法访问iCloud的情况
    }
}

func checkiCloudStorage2() {
    let fileManager = FileManager.default

    if let url = fileManager.url(forUbiquityContainerIdentifier: nil)?.appendingPathComponent("Documents") {
        do {
            let attributes = try fileManager.attributesOfFileSystem(forPath: url.path)

            let space = attributes[FileAttributeKey.systemSize] as? NSNumber
            let freeSpace = attributes[FileAttributeKey.systemFreeSize] as? NSNumber
            if let space = space, let freeSpace = freeSpace {
                let spaceGB = space.int64Value / 1024 / 1024 / 1024
                let freeSpaceGB = freeSpace.int64Value / 1024 / 1024 / 1024
                
                print("iCloud total space: \(spaceGB) GB")
                print("iCloud free space: \(freeSpaceGB) GB")
            }

        } catch {
            print(error)
        }
    }
}
