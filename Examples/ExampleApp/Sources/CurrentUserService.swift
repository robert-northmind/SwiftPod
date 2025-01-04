//
//  CurrentUserService.swift
//  ExampleApp
//
//  Created by Robert Magnusson on 04.01.25.
//

import SwiftPod

/// You can explicitly define the type for your provider as we do here.
/// This is useful when you are working with protocols.
let currentUserServiceProvider = Provider<CurrentUserServiceProtocol> { _ in
    return CurrentUserService()
}

protocol CurrentUserServiceProtocol {
    func username() -> String
}

class CurrentUserService: CurrentUserServiceProtocol {
    func username() -> String {
        return "Jane Doe"
    }
}

/// It is possible to define overrides for providers in the pod.
/// This way you can define that the pod should use a mock version instead of the real instance.
class MockUserService: CurrentUserServiceProtocol {
    let mockUsername: String
    
    init(mockUsername: String) {
        self.mockUsername = mockUsername
    }
    func username() -> String {
        return mockUsername
    }
}
