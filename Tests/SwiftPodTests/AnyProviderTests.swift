//
//  AnyProviderTests.swift
//  SwiftPod
//
//  Created by Robert Magnusson on 22.12.24.
//

import Testing
@testable import SwiftPod

struct AnyProviderTests {
    @Test("Build method calls build method on wrapped provider")
    func testCallsBuildMethodOnWrappedProvider() throws {
        let anyProvider = AnyProvider(fixedIntAsStringProvider)
        
        let result = anyProvider.build(providerResolver: MockProviderResolver())
        
        #expect(result as? String == "123")
    }
}
