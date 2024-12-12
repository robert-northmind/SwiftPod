//
//  ProviderOverrider.swift
//  SwiftPod
//
//  Created by Robert Magnusson on 11.12.24.
//

import Foundation

final class ProviderOverrider: @unchecked Sendable {
    init(instanceContainer: ProviderInstanceContainer) {
        self.instanceContainer = instanceContainer
    }

    private let dispatchQueue = DispatchQueue(label: "provider.overrider.lock.queue")
    
    private var overrideProviderBuilderDict = [AnyProvider: AnyProvider]()
    private var instanceContainer: ProviderInstanceContainer
    
    func getOverriddenAnyProvider(_ anyProvider: AnyProvider) -> AnyProvider? {
        let overrideAnyProvider = dispatchQueue.sync {
            return overrideProviderBuilderDict[anyProvider]
        }
        return overrideAnyProvider
    }

    func getOverriddenProviderInstance(_ anyProvider: AnyProvider) -> Any? {
        guard isProviderOverridden(anyProvider) else { return nil }

        let overriddenInstance = dispatchQueue.sync {
            return instanceContainer.get(anyProvider)
        }
        return overriddenInstance
    }

    func setOverrideInstance<T>(_ anyProvider: AnyProvider, _ newInstance: T) {
        dispatchQueue.sync {
            instanceContainer.set(anyProvider, newInstance)
        }
    }

    func isProviderOverridden(_ anyProvider: AnyProvider) -> Bool {
        let isOverridden = dispatchQueue.sync {
            return overrideProviderBuilderDict[anyProvider] != nil
        }
        return isOverridden
    }
    
    func removeOverride<T>(forProvider provider: Provider<T>) {
        dispatchQueue.sync {
            let anyProvider = AnyProvider(provider)
            instanceContainer.remove(anyProvider)
            overrideProviderBuilderDict.removeValue(forKey: anyProvider)
        }
    }
    
    public func overrideProvider<T>(
        _ provider: Provider<T>,
        with builder: @escaping @Sendable (ProviderResolver) -> T,
        scope: ProviderScope? = nil
    ) {
        dispatchQueue.sync {
            let anyProvider = AnyProvider(provider)
            let overrideAnyProvider = AnyProvider(
                Provider(scope: scope ?? provider.scope, builder)
            )

            instanceContainer.remove(anyProvider)
            overrideProviderBuilderDict[anyProvider] = overrideAnyProvider
        }
    }
}
