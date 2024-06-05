//
//  DependencyStore.swift
//
//
//  Created by MEGA_Mac on 2024/06/05.
//

import Foundation

public class DependencyStore {

    #if DEBUG
    public static var shared = DependencyStore()
    #else
    public static let shared = DependencyStore()
    #endif

    public init() {}

    /// A map of `identifier(for:)` to initializers
    private var store: [Identifier: () -> Any] = [:]

    func resolve<T>() -> T {
        let id = identifier(for: T.self)

        guard let initializer = store[id] else {
            fatalError("Could not resolve for \(T.self) - did you forget to `DependencyStore.register(_:)` a concrete type?")
        }

        guard let value = initializer() as? T else {
            // Never happens due to the register function being generic - this is needed only because `store.value` is `Any`
            fatalError("Could not cast \(initializer()) to \(T.self)")
        }

        return value
    }

    /// Registers a concrete dependency against protocol `T`.
    /// ```
    /// DependencyStore.register(Something(), for: SomethingType.self)
    /// ```
    public func register<T>(_ dependency: @escaping @autoclosure () -> T, for type: T.Type) {
        let id = identifier(for: T.self)
        store[id] = dependency
    }

}

private extension DependencyStore {
    typealias Identifier = String

    /// Generates a unique identifier for the given type
    func identifier<T>(for type: T) -> Identifier {
        String(describing: type)
    }
}

#if DEBUG
public extension DependencyStore {

    static let syncingQueue = DispatchQueue(label: "Dependencies.syncer")

    /// In a unit test, we need `@Injected` to read from self rather than the default `DependencyStore.shared`
    /// This does `DependencyStore.shared = self` and blocks all queues until `initializations` has been performed.
    /// Therefore `@Injected` items inside of `initializations` are guaranteed to initialise and maintain a reference to `self` which it will later use if needed.
    @discardableResult
    func execute<ReturnedValues>(_ initializations: @escaping () -> ReturnedValues) -> ReturnedValues {
        var anyReturnedValues: ReturnedValues!
        DependencyStore.syncingQueue.sync {

            let defaultInstance = DependencyStore.shared
            DependencyStore.shared = self
            anyReturnedValues = initializations()
            DependencyStore.shared = defaultInstance
        }
        return anyReturnedValues
    }

}
#endif
