//
//  InternalProviderResolver.swift
//  SwiftPod
//
//  Created by Robert Magnusson on 09.11.24.
//

struct InternalProviderResolver: ProviderResolver {
    init(_ pod: SwiftPod, processingAnyProviders: ProcessingAnyProviders) {
        self.pod = pod
        self.processingAnyProviders = processingAnyProviders
    }

    private let pod: SwiftPod
    private let processingAnyProviders: ProcessingAnyProviders

    public func resolve<T>(_ provider: Provider<T>) -> T {
        return pod.resolve(provider, processingAnyProviders: processingAnyProviders)
    }
}
