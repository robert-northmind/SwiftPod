//
//  ProviderScope.swift
//  SwiftPod
//
//  Created by Robert Magnusson on 17.10.24.
//

/// Controls the life time of the instances which your providers creates
public enum ProviderScope {
    /// The first time you resolve an instance with this scope, it will be created and persisted.
    /// If you try to resolve it again, then the initially created instance will be returned.
    case singleton

    /// Every time your try to resolve a provider with this scope a new instance will be created
    case alwaysCreateNew
}
