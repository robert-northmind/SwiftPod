//
//  SwiftPod.swift
//  SwiftPod
//
//  Created by Robert Magnusson on 17.10.24.
//

import Foundation

// TODO:
// 2: Add Scope clearing method. And test that child-scopes gets cleared also!
// 3: Add documentation and examples

public final class SwiftPod: ProviderResolver, @unchecked Sendable {
    public init() {
        self.providerOverrider = ProviderOverrider(instanceContainer: ProviderInstanceContainer())
    }

    private let dispatchQueue = DispatchQueue(label: "swiftpod.resolve.lock.queue")

    private let instanceContainer = ProviderInstanceContainer()
    private let providerOverrider: ProviderOverrider

    public func resolve<T>(_ originalProvider: Provider<T>) -> T {
        let theInstance = dispatchQueue.sync {
            let internalProviderResolver = InternalProviderResolver(
                instanceContainer: instanceContainer,
                processingAnyProviders: ProcessingAnyProviders.getInitial(),
                providerOverrider: providerOverrider
            )
            return internalProviderResolver.resolve(originalProvider)
        }
        return theInstance
    }

    public func overrideProvider<T>(
        _ provider: Provider<T>,
        with builder: @escaping @Sendable (ProviderResolver) -> T,
        scope: ProviderScope? = nil
    ) {
        dispatchQueue.sync {
            providerOverrider.overrideProvider(provider, with: builder, scope: scope)
        }
    }

    public func removeOverrideProvider<T>(_ provider: Provider<T>) {
        dispatchQueue.sync {
            providerOverrider.removeOverride(forProvider: provider)
        }
    }
}
