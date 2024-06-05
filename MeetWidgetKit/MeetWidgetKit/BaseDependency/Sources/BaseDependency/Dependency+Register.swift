//
//  Dependency+Register.swift
//
//
//  Created by MEGA_Mac on 2024/06/05.
//

import Foundation

import Core
import NetworkModule

extension DependencyStore {
    public func registerAll() {
        register(NetworkService_Rx.shared, for: NetworkServiceRxImpl.self)
        register(NetworkService_Combine.shared, for: NetworkServiceCombineImpl.self)
    }
}
