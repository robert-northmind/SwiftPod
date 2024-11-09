//
//  Provider.swift
//  SwiftPod
//
//  Created by Robert Magnusson on 17.10.24.
//

public class Provider<T>: Hashable {
    public init(scope: ProviderScope = SingletonScope(), _ builder: @escaping (ProviderResolver) -> T) {
        self.builder = builder
        self.scope = scope
    }

    private let builder: (ProviderResolver) -> T
    let scope: ProviderScope

    func build(_ providerResolver: ProviderResolver) -> T {
        return builder(providerResolver)
    }

    public static func == (lhs: Provider<T>, rhs: Provider<T>) -> Bool {
        return lhs === rhs
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(self))
    }
}
