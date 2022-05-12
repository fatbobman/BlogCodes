//
//  CloudStorage.swift
//  CloudStorage
//
//  Created by Tom Lokhorst on 2020-07-05.
//

import SwiftUI
import Combine

private let sync = CloudStorageSync.shared

@propertyWrapper public struct CloudStorage<Value>: DynamicProperty {
    private let _setValue: (Value) -> Void

    @ObservedObject private var backingObject: CloudStorageBackingObject<Value>

    public var projectedValue: Binding<Value>

    public var wrappedValue: Value {
        get { backingObject.value }
        nonmutating set { _setValue(newValue) }
    }

    public init(keyName key: String, syncGet: @escaping () -> Value, syncSet: @escaping (Value) -> Void) {
        let value = syncGet()

        let backing = CloudStorageBackingObject(value: value)
        self.backingObject = backing
        self.projectedValue = Binding(
            get: { backing.value },
            set: { [weak holder] newValue in
                backing.value = newValue
                holder?.sender?()
                syncSet(newValue)
                sync.synchronize()
            })
        self._setValue = { [weak holder] (newValue: Value) in
            backing.value = newValue
            holder?.sender?()
            syncSet(newValue)
            sync.synchronize()
        }

        sync.setObserver(for: key) { [weak backing] in
            backing?.value = syncGet()
        }
    }

    class Holder{
        var sender: (() -> Void)?
        init(){}
    }

    var holder = Holder()

    public static subscript<OuterSelf: ObservableObject>(
        _enclosingInstance observed: OuterSelf,
        wrapped wrappedKeyPath: ReferenceWritableKeyPath<OuterSelf, Value>,
        storage storageKeyPath: ReferenceWritableKeyPath<OuterSelf, Self>
    ) -> Value {
        get {
            if observed[keyPath: storageKeyPath].holder.sender == nil {
                observed[keyPath: storageKeyPath].holder.sender = { [weak observed] in
                    (observed?.objectWillChange as? ObservableObjectPublisher)?.send()
                }
            }
            return observed[keyPath: storageKeyPath].wrappedValue
        }
        set {
            if let subject = observed.objectWillChange as? ObservableObjectPublisher {
                subject.send()
                observed[keyPath: storageKeyPath].wrappedValue = newValue
            }
        }
    }
}

internal class CloudStorageBackingObject<Value>: ObservableObject {
    @Published var value: Value

    init(value: Value) {
        self.value = value
    }
}

extension CloudStorage where Value == Bool {
    public init(wrappedValue: Value, _ key: String) {
        self.init(
            keyName: key,
            syncGet: { sync.bool(for: key) ?? wrappedValue },
            syncSet: { newValue in sync.set(newValue, for: key) })
    }
}

extension CloudStorage where Value == Int {
    public init(wrappedValue: Value, _ key: String) {
        self.init(
            keyName: key,
            syncGet: { sync.int(for: key) ?? wrappedValue },
            syncSet: { newValue in sync.set(newValue, for: key) })
    }
}

extension CloudStorage where Value == Double {
    public init(wrappedValue: Value, _ key: String) {
        self.init(
            keyName: key,
            syncGet: { sync.double(for: key) ?? wrappedValue },
            syncSet: { newValue in sync.set(newValue, for: key) })
    }
}

extension CloudStorage where Value == String {
    public init(wrappedValue: Value, _ key: String) {
        self.init(
            keyName: key,
            syncGet: { sync.string(for: key) ?? wrappedValue },
            syncSet: { newValue in sync.set(newValue, for: key) })
    }
}

extension CloudStorage where Value == URL {
    public init(wrappedValue: Value, _ key: String) {
        self.init(
            keyName: key,
            syncGet: { sync.string(for: key).flatMap(URL.init(string:)) ?? wrappedValue },
            syncSet: { newValue in sync.set(newValue.absoluteString, for: key) })
    }
}

extension CloudStorage where Value == Data {
    public init(wrappedValue: Value, _ key: String) {
        self.init(
            keyName: key,
            syncGet: { sync.data(for: key) ?? wrappedValue },
            syncSet: { newValue in sync.set(newValue, for: key) })
    }
}

extension CloudStorage where Value: RawRepresentable, Value.RawValue == Int {
    public init(wrappedValue: Value, _ key: String) {
        self.init(
            keyName: key,
            syncGet: { sync.int(for: key).flatMap(Value.init) ?? wrappedValue },
            syncSet: { newValue in sync.set(newValue.rawValue, for: key) })
    }
}

extension CloudStorage where Value: RawRepresentable, Value.RawValue == String {
    public init(wrappedValue: Value, _ key: String) {
        self.init(
            keyName: key,
            syncGet: { sync.string(for: key).flatMap(Value.init) ?? wrappedValue },
            syncSet: { newValue in sync.set(newValue.rawValue, for: key) })
    }
}

extension CloudStorage where Value == Bool? {
    public init(_ key: String) {
        self.init(
            keyName: key,
            syncGet: { sync.bool(for: key) },
            syncSet: { newValue in sync.set(newValue, for: key) })
    }
}

extension CloudStorage where Value == Int? {
    public init(_ key: String) {
        self.init(
            keyName: key,
            syncGet: { sync.int(for: key) },
            syncSet: { newValue in sync.set(newValue, for: key) })
    }
}

extension CloudStorage where Value == Double? {
    public init(_ key: String) {
        self.init(
            keyName: key,
            syncGet: { sync.double(for: key) },
            syncSet: { newValue in sync.set(newValue, for: key) })
    }
}

extension CloudStorage where Value == String? {
    public init(_ key: String) {
        self.init(
            keyName: key,
            syncGet: { sync.string(for: key) },
            syncSet: { newValue in sync.set(newValue, for: key) })
    }
}

extension CloudStorage where Value == URL? {
    public init(_ key: String) {
        self.init(
            keyName: key,
            syncGet: { sync.string(for: key).flatMap(URL.init(string:)) },
            syncSet: { newValue in sync.set(newValue?.absoluteString, for: key) })
    }
}

extension CloudStorage where Value == Data? {
    public init(_ key: String) {
        self.init(
            keyName: key,
            syncGet: { sync.data(for: key) },
            syncSet: { newValue in sync.set(newValue, for: key) })
    }
}


//
//  CloudStorageSync.swift
//  CloudStorage
//
//  Created by Tom Lokhorst on 2020-07-05.
//

import Foundation

#if canImport(UIKit)
import UIKit
#endif

public class CloudStorageSync: ObservableObject {
    public static let shared = CloudStorageSync()

    private let ubiquitousKvs: NSUbiquitousKeyValueStore
    private var observers: [String: () -> Void] = [:]

    @Published private(set) public var status: Status

    private init() {
        ubiquitousKvs = NSUbiquitousKeyValueStore.default
        status = Status(date: Date(), source: .initial, keys: [])

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(didChangeExternally(notification:)),
            name: NSUbiquitousKeyValueStore.didChangeExternallyNotification,
            object: nil)
        ubiquitousKvs.synchronize()

        #if canImport(UIKit)
        NotificationCenter.default.addObserver(
            ubiquitousKvs,
            selector: #selector(NSUbiquitousKeyValueStore.synchronize),
            name: UIApplication.willEnterForegroundNotification,
            object: nil)
        #endif
    }

    @objc private func didChangeExternally(notification: Notification) {
        let reasonRaw = notification.userInfo?[NSUbiquitousKeyValueStoreChangeReasonKey] as? Int ?? -1
        let keys = notification.userInfo?[NSUbiquitousKeyValueStoreChangedKeysKey] as? [String] ?? []
        let reason = ChangeReason(rawValue: reasonRaw)

        status = Status(date: Date(), source: .externalChange(reason), keys: keys)

        // Use main queue as synchronization queue to get exclusive accessing to observers dictionary.
        // Since main queue is needed anyway to change UI properties.
        DispatchQueue.main.async {
            for key in keys {
                self.observers[key]?()
            }
        }
    }

    func setObserver(for key: String, handler: @escaping () -> Void) {
        // Use main queue as synchronization queue to get exclusive accessing to observers dictionary.
        // Since main queue is needed anyway to change UI properties.
        DispatchQueue.main.async {
            self.observers[key] = handler
        }
    }

    // Note:
    // As per the documentation of NSUbiquitousKeyValueStore.synchronize,
    // it is not nessesary to call .synchronize all the time.
    //
    // However, during developement, I very often quit or relaunch an app via Xcode debugger.
    // This causes the app to be killed before in-memory changes are persisted to disk.
    //
    // By excessively calling .synchronize() all the time, changes are persisted to disk.
    // This way, when working with Xcode, changes aren't constantly being reverted.
    internal func synchronize() {
        ubiquitousKvs.synchronize()
    }
}

// Wrap calls to NSUbiquitousKeyValueStore
extension CloudStorageSync {
    public func object(forKey key: String) -> Any? {
        ubiquitousKvs.object(forKey: key)
    }

    public func set(_ object: Any?, for key: String) {
        ubiquitousKvs.set(object, forKey: key)
    }

    public func remove(for key: String) {
        ubiquitousKvs.removeObject(forKey: key)
    }


    public func string(for key: String) -> String? {
        ubiquitousKvs.string(forKey: key)
    }

    public func array(for key: String) -> [Any]? {
        ubiquitousKvs.array(forKey: key)
    }

    public func dictionary(for key: String) -> [String : Any]? {
        ubiquitousKvs.dictionary(forKey: key)
    }

    public func data(for key: String) -> Data? {
        ubiquitousKvs.data(forKey: key)
    }

    public func int(for key: String) -> Int? {
        if ubiquitousKvs.object(forKey: key) == nil { return nil }
        return Int(ubiquitousKvs.longLong(forKey: key))
    }

    public func int64(for key: String) -> Int64? {
        if ubiquitousKvs.object(forKey: key) == nil { return nil }
        return ubiquitousKvs.longLong(forKey: key)
    }

    public func double(for key: String) -> Double? {
        if ubiquitousKvs.object(forKey: key) == nil { return nil }
        return ubiquitousKvs.double(forKey: key)
    }

    public func bool(for key: String) -> Bool? {
        if ubiquitousKvs.object(forKey: key) == nil { return nil }
        return ubiquitousKvs.bool(forKey: key)
    }


    public func set(_ value: String?, for key: String) {
        ubiquitousKvs.set(value, forKey: key)
        status = Status(date: Date(), source: .localChange, keys: [key])
    }

    public func set(_ value: Data?, for key: String) {
        ubiquitousKvs.set(value, forKey: key)
        status = Status(date: Date(), source: .localChange, keys: [key])
    }

    public func set(_ value: [Any]?, for key: String) {
        ubiquitousKvs.set(value, forKey: key)
        status = Status(date: Date(), source: .localChange, keys: [key])
    }

    public func set(_ value: [String : Any]?, for key: String) {
        ubiquitousKvs.set(value, forKey: key)
        status = Status(date: Date(), source: .localChange, keys: [key])
    }

    public func set(_ value: Int, for key: String) {
        ubiquitousKvs.set(value, forKey: key)
        status = Status(date: Date(), source: .localChange, keys: [key])
    }

    public func set(_ value: Int64, for key: String) {
        ubiquitousKvs.set(value, forKey: key)
        status = Status(date: Date(), source: .localChange, keys: [key])
    }

    public func set(_ value: Double, for key: String) {
        ubiquitousKvs.set(value, forKey: key)
        status = Status(date: Date(), source: .localChange, keys: [key])
    }

    public func set(_ value: Bool, for key: String) {
        ubiquitousKvs.set(value, forKey: key)
        status = Status(date: Date(), source: .localChange, keys: [key])
    }
}

extension CloudStorageSync {
    public enum ChangeReason {
        case serverChange
        case initialSyncChange
        case quotaViolationChange
        case accountChange

        init?(rawValue: Int) {
            switch rawValue {
            case NSUbiquitousKeyValueStoreServerChange:
                self = .serverChange
            case NSUbiquitousKeyValueStoreInitialSyncChange:
                self = .initialSyncChange
            case NSUbiquitousKeyValueStoreQuotaViolationChange:
                self = .quotaViolationChange
            case NSUbiquitousKeyValueStoreAccountChange:
                self = .accountChange
            default:
                assertionFailure("Unknown NSUbiquitousKeyValueStoreChangeReason \(rawValue)")
                return nil
            }
        }
    }

    public struct Status: CustomStringConvertible {
        public enum Source {
            case initial
            case localChange
            case externalChange(ChangeReason?)
        }

        public var date: Date
        public var source: Source
        public var keys: [String]

        public var description: String {
            let timeString = statusDateFormatter.string(from: date)
            let keysString = keys.joined(separator: ", ")

            switch source {
            case .initial:
                return "[\(timeString)] Initial"

            case .localChange:
                return "[\(timeString)] Local change: \(keysString)"

            case .externalChange(let reason?):
                return "[\(timeString)] External change (\(reason)): \(keysString)"

            case .externalChange(nil):
               return "[\(timeString)] External change (unknown): \(keysString)"
            }
        }
    }
}

private let statusDateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.timeStyle = .medium
    return formatter
}()
