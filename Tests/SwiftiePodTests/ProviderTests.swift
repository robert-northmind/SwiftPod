//
//  ProviderTests.swift
//  SwiftiePod
//
//  Created by Robert Magnusson on 21.10.24.
//

import Testing
@testable import SwiftiePod

struct ProviderTests {
    let provider1 = Provider(scope: AlwaysCreateNewScope()) { _ in
        return 1
    }
    let provider2 = Provider(scope: AlwaysCreateNewScope()) { _ in
        return 1
    }

    @Test("Test 2 different providers with same return value are not equal")
    func testProviderEquality() throws {
        #expect(provider1 != provider2)
        #expect(provider1.hashValue != provider2.hashValue)
        #expect(provider1 == provider1)
        #expect(provider1.hashValue == provider1.hashValue)
        #expect(provider2 == provider2)
        #expect(provider2.hashValue == provider2.hashValue)
    }
    
    @Test("Test build method of 2 different providers with same return value are same")
    func testProviderValueEquality() throws {
        let pod = SwiftiePod()
        let value1 = provider1.build(pod)
        let value2 = provider2.build(pod)

        #expect(value1 == value2)
    }
}
