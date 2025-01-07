//
//  SomeClass.swift
//  ExampleApp
//
//  Created by Robert Magnusson on 04.01.25.
//

import SwiftiePod

/// By using `AlwaysCreateNewScope` you make sure to
/// never cache the instances for `someClassFactoryProvider`.
let someClassFactoryProvider = Provider(scope: AlwaysCreateNewScope()) { _ in
    return SomeClass()
}

/// If you don't provide a scope, then the `SingletonScope` is applied to your provider.
/// This will cache the instance for the lifetime of the pod.
let someClassSingletonProvider = Provider { _ in
    return SomeClass()
}

/// You can also explicitly say that your provider should have the `SingletonScope`
let someClassExplicitSingletonProvider = Provider(scope: SingletonScope()) { _ in
    return SomeClass()
}

class SomeClass {}
