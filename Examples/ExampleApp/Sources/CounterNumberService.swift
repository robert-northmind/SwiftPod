//
//  CounterNumberService.swift
//  ExampleApp
//
//  Created by Robert Magnusson on 04.01.25.
//

import SwiftPod

let counterNumberProvider = Provider(scope: AlwaysCreateNewScope()) { _ in
    return pod.resolve(counterNumberServiceProvider).value
}

let counterNumberServiceProvider = Provider(scope: CounterNumberScope()) { _ in
    return CounterNumberService()
}

class CounterNumberService {
    private(set) var value: Int = 0

    func increase() {
        value += 1
    }
}
