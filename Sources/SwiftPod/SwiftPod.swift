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

    public func resolve<T>(_ provider: Provider<T>) -> T {
        let anyProvider = AnyProvider(provider)

        if isProviderOverridden(anyProvider) {
            let overrideAnyProvider = overrideProviderBuilderDict[anyProvider]
            let overrideProvider = overrideAnyProvider?.base as? Provider<T>
            let shouldAlwaysCreateNewInstance = overrideProvider?.scope is AlwaysCreateNewScope
            
            if !shouldAlwaysCreateNewInstance, let instance = overrideInstanceDict[anyProvider] as? T {
                return instance
            }

            if let newInstance = overrideAnyProvider?.build(pod: self) as? T {
                overrideInstanceDict[anyProvider] = newInstance
                return newInstance
            }
        }

        let shouldAlwaysCreateNewInstance = provider.scope is AlwaysCreateNewScope

        if !shouldAlwaysCreateNewInstance, let instance = instanceDict[anyProvider] as? T {
            return instance
        }
        let newInstance = provider.build(self)

        if !shouldAlwaysCreateNewInstance {
            instanceDict[anyProvider] = newInstance
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
