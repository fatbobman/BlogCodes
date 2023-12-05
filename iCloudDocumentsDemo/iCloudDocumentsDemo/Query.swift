//
//  Query.swift
//  iCloudDocumentsDemo
//
//  Created by Yang Xu on 2023/12/4.
//

import AsyncAlgorithms
import Foundation

class ItemQuery {
    let query = NSMetadataQuery()
    let queue: OperationQueue

    init(queue: OperationQueue = .main) {
        self.queue = queue
    }

    func searchMetadataItems(
        predicate: NSPredicate? = nil,
        sortDescriptors: [NSSortDescriptor] = [],
        scopes: [Any] = [NSMetadataQueryUbiquitousDocumentsScope]
    ) -> AsyncStream<[MetadataItemWrapper]> {
        query.searchScopes = scopes
        query.sortDescriptors = sortDescriptors
        // 获取 iCloud Ubiquity Container URL
        if let containerURL = FileManager.default.url(forUbiquityContainerIdentifier: nil)?.appendingPathComponent("Documents") {
            // 构建指向 Documents 目录的路径
            let documentsPath = containerURL.path

            // 使用动态路径创建谓词
            let defaultPredicate = NSPredicate(format: "%K BEGINSWITH %@", NSMetadataItemPathKey, documentsPath)
            query.predicate = predicate ?? defaultPredicate
        } else {
            // 如果无法获取路径，可以选择一个合适的默认行为
            query.predicate = predicate ?? NSPredicate(value: true)
        }

        return AsyncStream { continuation in
            NotificationCenter.default.addObserver(
                forName: .NSMetadataQueryDidFinishGathering,
                object: query,
                queue: queue
            ) { _ in
                let result = self.query.results.compactMap { item -> MetadataItemWrapper? in
                    guard let metadataItem = item as? NSMetadataItem else {
                        return nil
                    }
                    return MetadataItemWrapper(metadataItem: metadataItem)
                }
                continuation.yield(result)
            }

            NotificationCenter.default.addObserver(
                forName: .NSMetadataQueryDidUpdate,
                object: query,
                queue: queue
            ) { _ in
                let result = self.query.results.compactMap { item -> MetadataItemWrapper? in
                    guard let metadataItem = item as? NSMetadataItem else {
                        return nil
                    }
                    return MetadataItemWrapper(metadataItem: metadataItem)
                }
                continuation.yield(result)
            }

            query.start()

            continuation.onTermination = { @Sendable _ in
                self.query.stop()
                NotificationCenter.default.removeObserver(self, name: .NSMetadataQueryDidFinishGathering, object: self.query)
                NotificationCenter.default.removeObserver(self, name: .NSMetadataQueryDidUpdate, object: self.query)
            }
        }
    }
}

struct MetadataItemWrapper: Sendable {
    let fileName: String?
    let fileSize: Int?
    let contentType: String?
    let isPlaceholder: Bool
    let isDownloading: Bool
    let downloadAmount: Double?
    let isDirectory: Bool
    let isUploaded: Bool

    init(metadataItem: NSMetadataItem) {
        fileName = metadataItem.value(forAttribute: NSMetadataItemFSNameKey) as? String
        fileSize = metadataItem.value(forAttribute: NSMetadataItemFSSizeKey) as? Int
        contentType = metadataItem.value(forAttribute: NSMetadataItemContentTypeKey) as? String

        // 是否是占位文件
        isPlaceholder = metadataItem.value(forAttribute: NSMetadataUbiquitousItemDownloadingStatusKey) as? Bool ?? false

        // 当前下载量
        downloadAmount = metadataItem.value(forAttribute: NSMetadataUbiquitousItemPercentDownloadedKey) as? Double

        // 是否正在下载
        let downloadStatus = metadataItem.value(forAttribute: NSMetadataUbiquitousItemIsDownloadingKey) as? String
        isDownloading = downloadStatus == NSMetadataUbiquitousItemDownloadingStatusCurrent

        // 检查是否是目录
        if let contentType = metadataItem.value(forAttribute: NSMetadataItemContentTypeKey) as? String {
            isDirectory = (contentType == "public.folder")
        } else {
            isDirectory = false
        }

        // 检查文件是否已经上传成功或已经保存在云端
        let uploaded = metadataItem.value(forAttribute: NSMetadataUbiquitousItemIsUploadedKey) as? Bool ?? false
        let uploading = metadataItem.value(forAttribute: NSMetadataUbiquitousItemIsUploadingKey) as? Bool ?? true
        isUploaded = uploaded && !uploading
    }
}
