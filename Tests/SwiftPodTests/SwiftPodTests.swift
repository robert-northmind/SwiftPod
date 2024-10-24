//
//  ProviderScopeTests.swift
//  SwiftPod
//
//  Created by Robert Magnusson on 21.10.24.
//

import Testing
@testable import SwiftPod

struct SwiftPodTests {
    init() {
      pod = SwiftPod()
    }
    
    var pod: SwiftPod

    @Test("AlwaysCreateNewScope always creates a new instance")
    func testWithAlwaysCreateNewScope() async throws {
        let instance = pod.resolve(testAlwaysNewProvider)
        let instance2 = pod.resolve(testAlwaysNewProvider)
        let instance3 = pod.resolve(testAlwaysNewProvider)
        
        #expect(instance !== instance2)
        #expect(instance !== instance3)
        #expect(instance2 !== instance3)
    }
    
    @Test("NoScope always uses the same instance")
    func testProviderWithNoScope() async throws {
        let instance = pod.resolve(testStaticProvider)
        let instance2 = pod.resolve(testStaticProvider)
        let instance3 = pod.resolve(testStaticProvider)
        
        #expect(instance === instance2)
        #expect(instance === instance3)
    }
    
    @Test("OverrideProvider overrides the provider")
    func testOverrideProvider() async throws {
        let initialInstance = pod.resolve(testAlwaysNewProvider)
        #expect(initialInstance is SubTestClass == false)

        pod.overrideProvider(testAlwaysNewProvider) { _ in
            return SubTestClass()
        }

        let overriddenInstance = pod.resolve(testAlwaysNewProvider)
        #expect(overriddenInstance is SubTestClass)
    }
    
    @Test("RemoveOverrideProvider removes any overridden provider")
    func testRemoveOverrideProvider() async throws {
        pod.overrideProvider(testAlwaysNewProvider) { _ in
            return SubTestClass()
        }

        let overriddenInstance = pod.resolve(testAlwaysNewProvider)
        #expect(overriddenInstance is SubTestClass)

        pod.removeOverrideProvider(testAlwaysNewProvider)

        let nonOverriddenInstance = pod.resolve(testAlwaysNewProvider)
        #expect(nonOverriddenInstance is SubTestClass == false)
    }
    
    @Test("OverrideProvider uses same scope as provider when no scope provided")
    func testOverrideProviderWithNoScope() async throws {
        pod.overrideProvider(testAlwaysNewProvider) { _ in
            return SubTestClass()
        }

        let overriddenInstance1 = pod.resolve(testAlwaysNewProvider)
        let overriddenInstance2 = pod.resolve(testAlwaysNewProvider)

        #expect(overriddenInstance1 is SubTestClass)
        #expect(overriddenInstance2 is SubTestClass)
        #expect(overriddenInstance1 !== overriddenInstance2)
    }
    
    @Test("OverrideProvider uses passed in scope when provided")
    func testOverrideProviderWithCustomScope() async throws {
        pod.overrideProvider(
            testAlwaysNewProvider,
            with: { _ in
                return SubTestClass()
            },
            scope: SingletonScope()
        )

        let overriddenInstance1 = pod.resolve(testAlwaysNewProvider)
        let overriddenInstance2 = pod.resolve(testAlwaysNewProvider)

        #expect(overriddenInstance1 is SubTestClass)
        #expect(overriddenInstance2 is SubTestClass)
        #expect(overriddenInstance1 === overriddenInstance2)
    }
 
    private class TestClass {}
    
    private class SubTestClass: TestClass {}
    
    private let testAlwaysNewProvider = Provider(scope: AlwaysCreateNewScope()) { _ in
        return TestClass()
    }
    
    private let testStaticProvider = Provider { _ in
        return TestClass()
    }
}
