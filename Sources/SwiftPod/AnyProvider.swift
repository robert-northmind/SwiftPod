//
//  AnyProvider.swift
//  SwiftPod
//
//  Created by Robert Magnusson on 17.10.24.
//

// Type-erased wrapper for Provider
class AnyProvider: Hashable {
    let base: Any
    private let buildClosure: (SwiftPod) -> Any
    private let equalsClosure: (Any) -> Bool
    private let hashClosure: () -> Int

    init<T>(_ provider: Provider<T>) {
        self.base = provider
        self.buildClosure = { pod in
            return provider.build(pod)
        }
        self.equalsClosure = { other in
            guard let otherProvider = other as? Provider<T> else { return false }
            return provider === otherProvider
        }
        self.hashClosure = {
            return ObjectIdentifier(provider).hashValue
        }
    }

    func build(pod: SwiftPod) -> Any {
        return buildClosure(pod)
    }

    static func == (lhs: AnyProvider, rhs: AnyProvider) -> Bool {
        return lhs.equalsClosure(rhs.base)
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(hashClosure())
    }
}
