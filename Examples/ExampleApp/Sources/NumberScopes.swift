//
//  NumberScopes.swift
//  ExampleApp
//
//  Created by Robert Magnusson on 04.01.25.
//

import SwiftiePod

/// You can define custom scopes for your providers.
/// This is useful if you want to keep instances alive for a specific flow of your app,
/// for example during a log-in-flow. When the flow is complete you can then clear all instances for that scope.
///
/// Scopes can also have child scope, as you see here. Clearing the `AllNumbersScope`
/// will also clear the cached instances for `CounterNumberScope`.
final class AllNumbersScope: ProviderScope {
    let children: [any ProviderScope] = [CounterNumberScope()]
}

final class CounterNumberScope: ProviderScope {
    let children: [any ProviderScope] = []
}
