//
//  ProviderResolver.swift
//  SwiftiePod
//
//  Created by Robert Magnusson on 09.11.24.
//

/// The `ProviderResolver` knows how to get instances from your `Providers`
public protocol ProviderResolver: Sendable {
    /// Resolves a provider to its associated instance.
    ///
    /// - Parameter provider: The provider to resolve.
    /// - Returns: The instance associated with the given provider.
    func resolve<T>(_ provider: Provider<T>) -> T
}
