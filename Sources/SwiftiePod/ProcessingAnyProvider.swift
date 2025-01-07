//
//  ProcessingAnyProvider.swift
//  SwiftiePod
//
//  Created by Robert Magnusson on 09.11.24.
//

import Foundation

struct ProcessingAnyProvider: Hashable {
    let provider: AnyProvider
    let index: Int
    
    static func == (lhs: ProcessingAnyProvider, rhs: ProcessingAnyProvider) -> Bool {
        return lhs.provider === rhs.provider
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(provider)
    }
}

struct ProcessingAnyProviders: @unchecked Sendable {
    private static let dispatchQueue = DispatchQueue(label: "processing.any.providers.lock.queue")
    
    private let providers: Set<ProcessingAnyProvider>
    
    func contains(_ anyProvider: AnyProvider) -> Bool {
        let containsAnyProvider = Self.dispatchQueue.sync {
            return providers.contains { processingAnyProvider in
                return processingAnyProvider.provider == anyProvider
            }
        }
        return containsAnyProvider
    }
    
    func cycleErrorDescription(_ anyProvider: AnyProvider) -> String {
        let description = Self.dispatchQueue.sync {
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
        return description
    }
    
    static func getUpdated(_ processingAnyProviders: Self?, withAnyProvider anyProvider: AnyProvider) -> Self {
        let updatedProcessingAnyProviders = Self.dispatchQueue.sync {
            if let processingAnyProviders = processingAnyProviders {
                var providers = processingAnyProviders.providers
                providers.insert(ProcessingAnyProvider(provider: anyProvider, index: providers.count))
                return ProcessingAnyProviders(providers: providers)
            } else {
                return ProcessingAnyProviders(providers: [ProcessingAnyProvider(provider: anyProvider, index: 0)])
            }
        }
        return updatedProcessingAnyProviders
    }
    
    static func getInitial() -> Self {
        return ProcessingAnyProviders(providers: [])
    }
}
