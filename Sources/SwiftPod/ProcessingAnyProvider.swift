//
//  ProcessingAnyProvider.swift
//  SwiftPod
//
//  Created by Robert Magnusson on 09.11.24.
//

struct ProcessingAnyProvider: Hashable {
    let provider: AnyProvider
    let index: Int
    
    public static func == (lhs: ProcessingAnyProvider, rhs: ProcessingAnyProvider) -> Bool {
        return lhs.provider === rhs.provider
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(provider)
    }
}

struct ProcessingAnyProviders {
    private let providers: Set<ProcessingAnyProvider>
    
    func contains(_ anyProvider: AnyProvider) -> Bool {
        return providers.contains { processingAnyProvider in
            return processingAnyProvider.provider == anyProvider
        }
    }
    
    func cycleErrorDescription(_ anyProvider: AnyProvider) -> String {
        let sortedProviders = providers.sorted { lhs, rhs in
            lhs.index < rhs.index
        }
        let providerDescriptions = sortedProviders.map { processingAnyProvider -> String in
            if processingAnyProvider.provider == anyProvider {
                return "\(processingAnyProvider.provider) <-- (This was the same provider)"
            } else {
                return "\(processingAnyProvider.provider)"
            }
        }
        return "Dependencies cycle detected when trying to resolve \(anyProvider).\nStack of previously resolved providers:\n[\(providerDescriptions.joined(separator: ", "))]"
    }
    
    static func getUpdated(_ processingAnyProviders: Self?, withAnyProvider anyProvider: AnyProvider) -> Self {
        if let processingAnyProviders = processingAnyProviders {
            var providers = processingAnyProviders.providers
            providers.insert(ProcessingAnyProvider(provider: anyProvider, index: providers.count))
            return ProcessingAnyProviders(providers: providers)
        } else {
            return ProcessingAnyProviders(providers: [ProcessingAnyProvider(provider: anyProvider, index: 0)])
        }
    }
}
