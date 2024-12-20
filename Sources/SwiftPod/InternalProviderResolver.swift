//
//  InternalProviderResolver.swift
//  SwiftPod
//
//  Created by Robert Magnusson on 09.11.24.
//

import Foundation

struct InternalProviderResolver: ProviderResolver {
    init(
        instanceContainer: ProviderInstanceContainer,
        processingAnyProviders: ProcessingAnyProviders,
        providerOverrider: ProviderOverrider
    ) {
        self.instanceContainer = instanceContainer
        self.processingAnyProviders = processingAnyProviders
        self.providerOverrider = providerOverrider
    }

    private let instanceContainer: ProviderInstanceContainer
    private let processingAnyProviders: ProcessingAnyProviders
    private let providerOverrider: ProviderOverrider

    public func resolve<T>(_ originalProvider: Provider<T>) -> T {
        let anyProvider = AnyProvider(originalProvider)
        
        let overriddenAnyProvider = providerOverrider.getOverriddenAnyProvider(originalProvider)
        let wasOverridden = providerOverrider.isProviderOverridden(originalProvider)
        let provider = (wasOverridden ? overriddenAnyProvider?.base as? Provider<T> : originalProvider) ?? originalProvider

        let isAllowedToCacheInstance = !(provider.scope is AlwaysCreateNewScope)
        
        if isAllowedToCacheInstance {
            if wasOverridden {
                if let overriddenInstance = providerOverrider.getOverriddenProviderInstance(originalProvider) as? T {
                    return overriddenInstance
                }
            } else if let instance = instanceContainer.get(anyProvider) as? T {
                return instance
            }
        }

        checkCyclicDependency(anyProvider: anyProvider, processingAnyProviders: processingAnyProviders)

        let newInstance = provider.build(
            InternalProviderResolver(
                instanceContainer: instanceContainer,
                processingAnyProviders: ProcessingAnyProviders.getUpdated(
                    processingAnyProviders,
                    withAnyProvider: anyProvider
                ),
                providerOverrider: providerOverrider
            )
        )

        if isAllowedToCacheInstance {
            if wasOverridden {
                providerOverrider.setOverrideInstance(originalProvider, newInstance)
            } else {
                instanceContainer.set(anyProvider, newInstance)
            }
        }

        return newInstance
    }
    
    private func checkCyclicDependency(anyProvider: AnyProvider, processingAnyProviders: ProcessingAnyProviders?) {
        if let processingAnyProviders = processingAnyProviders, processingAnyProviders.contains(anyProvider) {
            let providerDescriptions = processingAnyProviders.cycleErrorDescription(anyProvider)
            assert(false, "\n\(providerDescriptions)");
        }
    }
}
