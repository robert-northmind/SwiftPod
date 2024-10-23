//
//  SwiftPod.swift
//  SwiftPod
//
//  Created by Robert Magnusson on 17.10.24.
//

import Foundation

public class SwiftPod {
    public init() {}

    private var instanceDict = [AnyProvider: Any]()

    private var overrideInstanceDict = [AnyProvider: Any]()
    private var overrideProviderBuilderDict = [AnyProvider: AnyProvider]()

    public func resolve<T>(_ originalProvider: Provider<T>) -> T {
        let originalAnyProvider = AnyProvider(originalProvider)
        let overrideAnyProvider = overrideProviderBuilderDict[originalAnyProvider]
        let anyProvider = overrideAnyProvider ?? originalAnyProvider

        let wasOverridden = isProviderOverridden(originalAnyProvider)
        let provider = anyProvider.base as? Provider<T> ?? originalProvider
        
        let isAllowedToCacheInstance = !(provider.scope is AlwaysCreateNewScope)
        
        if isAllowedToCacheInstance {
            if wasOverridden, let instance = overrideInstanceDict[anyProvider] as? T {
                return instance
            } else if let instance = instanceDict[anyProvider] as? T {
                return instance
            }
        }
        
        let newInstance = provider.build(self)
        if isAllowedToCacheInstance {
            if wasOverridden {
                overrideInstanceDict[anyProvider] = newInstance
            } else {
                instanceDict[anyProvider] = newInstance
            }
        }
        return newInstance
    }

    private func isProviderOverridden(_ anyProvider: AnyProvider) -> Bool {
        return overrideProviderBuilderDict[anyProvider] != nil
    }

    public func overrideProvider<T>(
        _ provider: Provider<T>,
        with builder: @escaping (SwiftPod) -> T,
        scope: ProviderScope? = nil
    ) {
        let anyProvider = AnyProvider(provider)
        let overrideAnyProvider = AnyProvider(Provider(
            scope: scope ?? provider.scope,
            builder
        ))
        
        overrideInstanceDict.removeValue(forKey: anyProvider)
        overrideProviderBuilderDict[anyProvider] = overrideAnyProvider
    }

    public func removeOverrideProvider<T>(_ provider: Provider<T>) {
        let anyProvider = AnyProvider(provider)
        overrideInstanceDict.removeValue(forKey: anyProvider)
        overrideProviderBuilderDict.removeValue(forKey: anyProvider)
    }
}
