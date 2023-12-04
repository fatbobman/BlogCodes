//
//  ContentView.swift
//  iCloudDocumentsDemo
//
//  Created by Yang Xu on 2023/12/4.
//

import SwiftUI

struct ContentView: View {
    @State var handler = CloudDocumentsHandler()
    var containerURL: URL? {
        let containerIdentifier = "iCloud.com.fatbobman.iCloudDocumentsDemoContainer"
        guard let containerURL = FileManager.default.url(forUbiquityContainerIdentifier: containerIdentifier) else {
            return nil
        }
        return containerURL
    }

    var documentURL: URL? {
        let documentsFolderURL = containerURL?.appendingPathComponent("Documents")
        return documentsFolderURL
    }

    var body: some View {
        List {
            Group {
                Button("Create File in Documents") {
                    Task.detached {
                        let hander = self.handler
                        guard let documentURL else { fatalError() }
                        let fileURL = documentURL.appending(path: "hello.txt")
                        do {
                            try await hander.write(targetURL: fileURL, data: "hello world".data(using: .utf8)!)
                        } catch {
                            print(error)
                        }
                    }
                }
                Button("Read Hello world from Documents") {
                    Task {
                        let hander = self.handler
                        guard let documentURL else { fatalError() }
                        let fileURL = documentURL.appending(path: "hello.txt")
                        do {
                            let data = try await hander.read(url: fileURL)
                            print(String(data: data, encoding: .utf8) ?? "nil")
                        } catch {
                            print(error)
                        }
                    }
                }
                Button("Read File & Monitor") {
                    Task {
                        let hander = self.handler
                        guard let documentURL else { fatalError() }
                        let fileURL = documentURL.appending(path: "hello.txt")
                        print(fileURL)
                        do {
                            let data = try await hander.read(url: fileURL)
                            print(String(data: data, encoding: .utf8) ?? "nil")
                        } catch {
                            print(error)
                        }
                        await hander.startMonitoringFile(at: fileURL)
                    }
                }
                Button("Stop Monitor") {
                    Task {
                        let hander = self.handler
                        guard let documentURL else { fatalError() }
                        let fileURL = documentURL.appending(path: "hello.txt")
                        await hander.stopMonitoringFile(at: fileURL)
                    }
                }
                Button("Monitor Directory") {
                    Task {
                        let hander = self.handler
                        guard let documentURL else { fatalError() }
                        await hander.startMonitoringFile(at: documentURL)
                    }
                }
                Button("Stop Monitor Directory") {
                    Task {
                        let hander = self.handler
                        guard let documentURL else { fatalError() }
                        await hander.stopMonitoringFile(at: documentURL)
                    }
                }
            }
            Button("Get Document File List") {
                Task {
                    let query = ItemQuery()
                    for await items in query.searchMetadataItems().throttle(for: .seconds(1), latest: true) {
                        items.forEach {
                            print($0.fileName ?? "", $0.isDirectory)
                        }
                    }
                }
            }
            Button("Get StartWith H and in Root") {
                Task {
                    print("start")
                    let query = ItemQuery()
                    let containerIdentifier = "iCloud.com.fatbobman.iCloudDocumentsDemoContainer"
                    guard let containerURL = FileManager.default.url(forUbiquityContainerIdentifier: containerIdentifier) else {
                        return
                    }
                    let predicateFormat = "((%K BEGINSWITH[cd] 'h') AND (%K BEGINSWITH %@)) AND (%K.pathComponents.@count == %d)"
                    let predicate = NSPredicate(format: predicateFormat,
                                                NSMetadataItemFSNameKey,
                                                NSMetadataItemPathKey,
                                                containerURL.path,
                                                NSMetadataItemPathKey,
                                                containerURL.pathComponents.count + 1)
                    for await items in query.searchMetadataItems(predicate: predicate, scopes: [NSMetadataQueryUbiquitousDataScope]).throttle(for: .seconds(1), latest: true) {
                        items.forEach {
                            print($0.fileName ?? "", $0.isDirectory)
                        }
                    }
                }
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
