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
    let isDirectory: Bool
    let url: URL?
    let isPlaceholder: Bool
    let isDownloading: Bool
    let downloadProgress: Double
    let uploaded: Bool

    init(metadataItem: NSMetadataItem) {
        fileName = metadataItem.value(forAttribute: NSMetadataItemFSNameKey) as? String
        fileSize = metadataItem.value(forAttribute: NSMetadataItemFSSizeKey) as? Int
        contentType = metadataItem.value(forAttribute: NSMetadataItemContentTypeKey) as? String

        // 检查是否是目录
        if let contentType = metadataItem.value(forAttribute: NSMetadataItemContentTypeKey) as? String {
            isDirectory = (contentType == "public.folder")
        } else {
            isDirectory = false
        }

        url = metadataItem.value(forAttribute: NSMetadataItemURLKey) as? URL

        if let downloadingStatus = metadataItem.value(forAttribute: NSMetadataUbiquitousItemDownloadingStatusKey) as? String {
            if downloadingStatus == NSMetadataUbiquitousItemDownloadingStatusNotDownloaded {
                // 文件是占位文件
                isPlaceholder = true
            } else if downloadingStatus == NSMetadataUbiquitousItemDownloadingStatusDownloaded || downloadingStatus == NSMetadataUbiquitousItemDownloadingStatusCurrent {
                // 文件已下载或是最新的
                isPlaceholder = false
            } else {
                isPlaceholder = false
            }
        } else {
            // 默认值，假设文件不是占位文件
            isPlaceholder = false
        }

        // 获取下载进度
        downloadProgress = metadataItem.value(forAttribute: NSMetadataUbiquitousItemPercentDownloadedKey) as? Double ?? 0.0

        // 如果是占位文件且下载进度大于0且小于100，则认为文件正在下载
        isDownloading = isPlaceholder && downloadProgress > 0.0 && downloadProgress < 100.0

        // 是否已经上传完毕(只有 0 和 100 两个状态)
        uploaded = (metadataItem.value(forAttribute: NSMetadataUbiquitousItemPercentUploadedKey) as? Double ?? 0.0) == 100
    }
}
