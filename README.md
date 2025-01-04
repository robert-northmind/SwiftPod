# SwiftPod

SwiftPod is a lightweight dependency injection container for Swift. It lets you define providers for creating instances, ensuring clear separation of concerns.

## Installation

Add this package to your Swift Package Manager dependencies:

```swift
dependencies: [
    .package(url: "https://github.com/username/SwiftPod.git", from: "1.0.0")
]
```

## Usage

```swift
import SwiftPod

// Define a provider
let myServiceProvider = Provider { _ in MyService() }
// Resolve its instance
let myService = pod.resolve(myServiceProvider)
```

## License

Distributed under the MIT license.

## TODO:

- Add example app to showcase
- Add Readme. Add example to readme. Add swift package manager Badge
- Deploy app to Swift package manager index
- Update CI to auto deploy
- Remove old github tags. re-deploy as 1.0.0
- Try it in my SonoWatch!
