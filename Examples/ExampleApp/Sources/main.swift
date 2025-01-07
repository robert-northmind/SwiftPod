import SwiftiePod

print("## Starting example app")

// Create your pod. You then use this throughout your app to resolve your types.
let pod = SwiftiePod()

// Use the pod to get the instances of SomeClass.
// Never create the instance directly in code.
// Just use the pod :-D
let someClass1 = pod.resolve(someClassFactoryProvider)
let someClass2 = pod.resolve(someClassFactoryProvider)
// SomeClass-Factory-instances are the same:
print("\(someClass1 === someClass2)") // Prints False

let someClass3 = pod.resolve(someClassSingletonProvider)
let someClass4 = pod.resolve(someClassSingletonProvider)
// SomeClass-Singleton-instances are the same:
print("\(someClass3 === someClass4)") // Prints True

// Use the pod to get a random number generator
let randomNumberGenerator = pod.resolve(randomNumberGeneratorProvider)
randomNumberGenerator.generateNew()
print("Random number: \(randomNumberGenerator.value)")

// Get the random number generator again.
// It will be the same instance, since it is cached by the pod.
let randomNumberGenerator2 = pod.resolve(randomNumberGeneratorProvider)
// RandomNumberGenerators are same instances:
print("\(randomNumberGenerator === randomNumberGenerator2)") // Prints True

// Get a counter number service
let counterNumberService = pod.resolve(counterNumberServiceProvider)
counterNumberService.increase()
print("Current counter value: \(counterNumberService.value)")

// Get the counter number service again.
// It will be the same instance, since it is cached by the pod.
let counterNumberService2 = pod.resolve(counterNumberServiceProvider)
// CounterNumberServices are same instances:
print("\(counterNumberService === counterNumberService2)") // Prints True

// Clear the numbers scope.
// This will reset any cached instances for those scopes and its child scopes.
pod.clearCachedInstances(forScope: AllNumbersScope())
print("Did clear all cached values for AllNumbersScope")

let randomNumberGenerator3 = pod.resolve(randomNumberGeneratorProvider)
let counterNumberService3 = pod.resolve(counterNumberServiceProvider)
// RandomNumberGenerators are same instances:
print("\(randomNumberGenerator === randomNumberGenerator3)") // Prints False
// CounterNumberServices are same instances:
print("\(counterNumberService === counterNumberService3)") // Prints False

// Get a greetings service, which depends on the current user service
var greetingsService = pod.resolve(greetingsServiceProvider)
print(greetingsService.greetings()) // Prints Hello there Jane Doe!

// Override the current user service. This will make the greetings service use a new value
pod.overrideProvider(currentUserServiceProvider) { _ in
    return MockUserService(mockUsername: "Mocky Mocksson")
}
greetingsService = pod.resolve(greetingsServiceProvider)
print(greetingsService.greetings()) // Prints Hello there Mocky Mocksson!

// Resetting override, makes the greetings service use the original value
pod.removeOverrideProvider(currentUserServiceProvider)
greetingsService = pod.resolve(greetingsServiceProvider)
print(greetingsService.greetings()) // Prints Hello there Jane Doe!

print("## Completed example app")
