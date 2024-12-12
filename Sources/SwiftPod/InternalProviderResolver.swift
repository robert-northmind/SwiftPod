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
        let anyProvider = getAnyProvider(originalProvider)

        let wasOverridden = providerOverrider.isProviderOverridden(anyProvider)
        let provider = anyProvider.base as? Provider<T> ?? originalProvider
        
        let isAllowedToCacheInstance = !(provider.scope is AlwaysCreateNewScope)
        
        if isAllowedToCacheInstance {
            if wasOverridden, let overriddenInstance = providerOverrider.getOverriddenProviderInstance(anyProvider) as? T {
                return overriddenInstance
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
                providerOverrider.setOverrideInstance(anyProvider, newInstance)
            } else {
                instanceContainer.set(anyProvider, newInstance)
            }
        }

        return newInstance
    }
    
    private func getAnyProvider<T>(_ provider: Provider<T>) -> AnyProvider {
        let originalAnyProvider = AnyProvider(provider)
        let overriddenAnyProvider = providerOverrider.getOverriddenAnyProvider(originalAnyProvider)
        return overriddenAnyProvider ?? originalAnyProvider
    }
    
    private func checkCyclicDependency(anyProvider: AnyProvider, processingAnyProviders: ProcessingAnyProviders?) {
        if let processingAnyProviders = processingAnyProviders, processingAnyProviders.contains(anyProvider) {
            let providerDescriptions = processingAnyProviders.cycleErrorDescription(anyProvider)
            assert(false, "\n\(providerDescriptions)");
        }
    }
}
