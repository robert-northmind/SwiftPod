//
//  RandomNumberGenerator.swift
//  ExampleApp
//
//  Created by Robert Magnusson on 04.01.25.
//

import SwiftPod

let randomNumberProvider = Provider(scope: AlwaysCreateNewScope()) { _ in
    return pod.resolve(randomNumberGeneratorProvider).value
}

let randomNumberGeneratorProvider = Provider(scope: AllNumbersScope()) { _ in
    return RandomNumberGenerator()
}

class RandomNumberGenerator {
    private(set) var value: Int

    init() {
        value = Self.getRandomInt()
    }
    
    func generateNew() {
        value = Self.getRandomInt()
    }

    static private func getRandomInt() -> Int {
        return Int.random(in: 0..<100)
    }
}
