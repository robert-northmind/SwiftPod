//
//  ProviderScope.swift
//  SwiftiePod
//
//  Created by Robert Magnusson on 17.10.24.
//

/// Controls the caching/life-time of the instances which your providers creates
public protocol ProviderScope: Sendable {
    var children: [ProviderScope] { get }
}

/// Every time your try to resolve a provider with this scope a new instance will be created
public struct AlwaysCreateNewScope: ProviderScope {
    public init() {}

    public var children = [ProviderScope]()
}

/// The first time you try to resolve a provider with this scope a new instance will be created.
/// That instance will then be cached, and every following resolve will reuse that cached instance.
public struct SingletonScope: ProviderScope {
    public init() {}

    public var children = [ProviderScope]()
}
