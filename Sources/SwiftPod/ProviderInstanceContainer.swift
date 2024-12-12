//
//  ProviderInstanceContainer.swift
//  SwiftPod
//
//  Created by Robert Magnusson on 11.12.24.
//

import Foundation

final class ProviderInstanceContainer: @unchecked Sendable {
    private let dispatchQueue = DispatchQueue(label: "instance.container.lock.queue")

    private var instanceDict = [AnyProvider: Any]()

    func get(_ anyProvider: AnyProvider) -> Any? {
        let instance = dispatchQueue.sync {
            return instanceDict[anyProvider]
        }
        return instance
    }

    func set<T>(_ anyProvider: AnyProvider, _ newInstance: T) {
        dispatchQueue.sync {
            instanceDict[anyProvider] = newInstance
        }
    }

    func remove(_ anyProvider: AnyProvider) {
        dispatchQueue.sync {
            _ = instanceDict.removeValue(forKey: anyProvider)
        }
    }
}
