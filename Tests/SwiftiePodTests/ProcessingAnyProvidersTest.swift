//
//  ProcessingAnyProvidersTest.swift
//  SwiftiePod
//
//  Created by Robert Magnusson on 20.12.24.
//

import Testing
@testable import SwiftiePod

struct ProcessingAnyProvidersTests {
    @Test("Contains returns true if provider is contained")
    func testContainsWhenProviderIsContained() {
        let sut = ProcessingAnyProviders.getUpdated(
            ProcessingAnyProviders.getInitial(),
            withAnyProvider: AnyProvider(randomIntAsStringProvider)
        )
        let contains = sut.contains(AnyProvider(randomIntAsStringProvider))
        #expect(contains == true)
    }
    
    @Test("Contains returns false if provider is not contained")
    func testNotContainsWhenProviderIsNotContained() {
        let sut = ProcessingAnyProviders.getInitial()
        let contains = sut.contains(AnyProvider(randomIntAsStringProvider))
        #expect(contains == false)
    }
    
    @Test("Cycle Error Description returns correct text")
    func testCycleErrorDescription() {
        var sut = ProcessingAnyProviders.getUpdated(
            nil,
            withAnyProvider: AnyProvider(randomIntAsStringProvider)
        )
        sut = ProcessingAnyProviders.getUpdated(
            sut,
            withAnyProvider: AnyProvider(randomIntProvider)
        )
        let errorDesc = sut.cycleErrorDescription(AnyProvider(randomIntProvider))
        
        let expectedErrorDesc = """
Dependencies cycle detected when trying to resolve Provider<Int>.
Stack of previously resolved providers:
[Provider<String>, Provider<Int> <-- (This was the same provider)]
"""

        #expect(errorDesc == expectedErrorDesc)
    }
}
