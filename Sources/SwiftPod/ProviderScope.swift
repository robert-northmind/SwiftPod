//
//  ProviderScope.swift
//  SwiftPod
//
//  Created by Robert Magnusson on 17.10.24.
//

/// Controls the life time of the instances which your providers creates
public protocol ProviderScope {
    var children: [ProviderScope] { get }
}

/// Every time your try to resolve a provider with this scope a new instance will be created
public struct AlwaysCreateNewScope: ProviderScope {
    public init() {}

    public var children = [ProviderScope]()
}

public struct SingletonScope: ProviderScope {
    public init() {}

    public var children = [ProviderScope]()
}
