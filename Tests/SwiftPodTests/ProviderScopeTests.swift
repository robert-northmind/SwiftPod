//
//  ProviderScopeTests.swift
//  SwiftPod
//
//  Created by Robert Magnusson on 21.10.24.
//

import Testing
@testable import SwiftPod

struct ProviderScopeTests {
    @Test("AlwaysCreateNewScope has no children")
    func testAlwaysCreateNewScope() {
        let scope = AlwaysCreateNewScope()
        #expect(scope.children.isEmpty)
    }
    
    @Test("SingletonScope has no children")
    func testSingletonScope() {
        let scope = SingletonScope()
        #expect(scope.children.isEmpty)
    }
}
