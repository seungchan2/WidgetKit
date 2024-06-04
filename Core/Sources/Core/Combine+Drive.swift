//
//  Combine+Drive.swift
//  MeetWidgetKit
//
//  Created by MEGA_Mac on 2024/06/04.
//

import Combine
import Foundation

public typealias CombineDriver<T> = AnyPublisher<T, Never>

public extension Publisher {
    func asDriver() -> CombineDriver<Output> {
        return self.catch { _ in Empty() }
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }
    
    static func just(_ output: Output) -> CombineDriver<Output> {
        return Just(output).eraseToAnyPublisher()
    }
    
    static func empty() -> CombineDriver<Output> {
        return Empty().eraseToAnyPublisher()
    }
    
    func mapVoid() -> AnyPublisher<Void, Failure> {
        return self.map { _ in () }
            .eraseToAnyPublisher()
    }
}
