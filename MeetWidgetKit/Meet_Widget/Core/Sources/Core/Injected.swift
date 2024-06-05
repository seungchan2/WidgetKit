//
//  Injected.swift
//  
//
//  Created by MEGA_Mac on 2024/06/05.
//

import Foundation

@propertyWrapper
public class Injected<T> {
    
    private var storage: T?
    
    private let dependencyStore: DependencyStore
    
    public init() {
        dependencyStore = DependencyStore.shared
    }
    
    public var wrappedValue: T {
        if let storage = storage { return storage }
        let object: T = dependencyStore.resolve()
        storage = object
        return object
    }
    
}
