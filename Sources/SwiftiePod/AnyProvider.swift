//
//  AnyProvider.swift
//  SwiftiePod
//
//  Created by Robert Magnusson on 17.10.24.
//

// Type-erased wrapper for Provider
class AnyProvider: Hashable, CustomStringConvertible {
    let base: Any
    let scope: ProviderScope

    private let buildClosure: (ProviderResolver) -> Any
    private let equalsClosure: (Any) -> Bool
    private let hashClosure: () -> Int

    init<T>(_ provider: Provider<T>) {
        self.base = provider
        self.scope = provider.scope
        self.buildClosure = { providerResolver in
            return provider.build(providerResolver)
        }
        self.equalsClosure = { other in
            guard let otherProvider = other as? Provider<T> else { return false }
            return provider === otherProvider
        }
        self.hashClosure = {
            return provider.hashValue
        }
    }

    func build(providerResolver: ProviderResolver) -> Any {
        return buildClosure(providerResolver)
    }

    static func == (lhs: AnyProvider, rhs: AnyProvider) -> Bool {
        return lhs.equalsClosure(rhs.base)
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(hashClosure())
    }

    var description: String {
        return String(describing: type(of: base))
    }
}
