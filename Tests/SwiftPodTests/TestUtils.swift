//
//  TestUtils.swift
//  SwiftPod
//
//  Created by Robert Magnusson on 22.12.24.
//

import Foundation
@testable import SwiftPod

class TestClass {}

class SubTestClass: TestClass {}

final class CustomParentScope: ProviderScope {
    let children: [any ProviderScope] = [CustomChildScope()]
}

final class CustomChildScope: ProviderScope {
    let children: [any ProviderScope] = [CustomGrandChildScope()]
}

final class CustomGrandChildScope: ProviderScope {
    let children: [any ProviderScope] = []
}

final class CustomOtherScope: ProviderScope {
    let children: [any ProviderScope] = []
}

let testAlwaysNewProvider = Provider(scope: AlwaysCreateNewScope()) { _ in
    return TestClass()
}

let testStaticProvider = Provider { _ in
    return TestClass()
}

let testCustomParentScopeProvider = Provider(scope: CustomParentScope()) { _ in
    return TestClass()
}

let testCustomChildScopeProvider = Provider(scope: CustomChildScope()) { _ in
    return TestClass()
}

let testCustomGrandChildScopeProvider = Provider(scope: CustomGrandChildScope()) { _ in
    return TestClass()
}

let testCustomOtherScopeProvider = Provider(scope: CustomOtherScope()) { _ in
    return TestClass()
}

let randomIntProvider = Provider<Int>({ _ in
    return (Int.random(in: 0..<100))
})

let randomIntAsStringProvider = Provider<String>({ pod in
    let theInt = pod.resolve(randomIntProvider)
    return "\(theInt)"
})

let fixedIntProvider = Provider<Int>({ _ in
    return 123
})

let fixedIntAsStringProvider = Provider<String>({ pod in
    let theInt = pod.resolve(fixedIntProvider)
    return "\(theInt)"
})

let cyclicProvider: Provider<Int> = Provider { pod in
    return pod.resolve(cyclicProvider)
}

struct MockProviderResolver: ProviderResolver {
    func resolve<T>(_ provider: Provider<T>) -> T {
        return provider.build(self)
    }
}

extension DispatchGroup {
    func waitForCompletion() async {
        await withCheckedContinuation { continuation in
            self.notify(queue: .main) {
                continuation.resume()
            }
        }
    }
}
