//
//  GreetingsService.swift
//  ExampleApp
//
//  Created by Robert Magnusson on 04.01.25.
//

import SwiftPod

/// You can use the `pod` parameter to resolve other 
/// types which you might need to create your services.
let greetingsServiceProvider = Provider(scope: AlwaysCreateNewScope()) { pod in
    return GreetingsService(
        currentUserService: pod.resolve(currentUserServiceProvider)
    )
}

class GreetingsService {
    private let currentUserService: CurrentUserServiceProtocol

    init(currentUserService: CurrentUserServiceProtocol) {
        self.currentUserService = currentUserService
    }

    func greetings() -> String {
        return "Hello there \(currentUserService.username())!"
    }
}
