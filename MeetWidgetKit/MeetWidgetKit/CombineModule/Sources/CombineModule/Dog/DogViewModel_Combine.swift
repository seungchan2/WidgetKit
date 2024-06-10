//
//  File.swift
//  
//
//  Created by MEGA_Mac on 2024/06/04.
//

import Combine
import UIKit

import Core
import NetworkModule

public final class DogViewModel_Combine: ViewModelType_Combine {
    @Injected private var service: NetworkServiceCombineImpl
    public var cancelBag = CancelBag()

    public init() {}
    public struct Input {
        let didFetchButtonTapped: AnyPublisher<Void, Never>
    }
    
    public struct Output {
        let fetchedDogImage: CombineDriver<UIImage?>
    }
    
    public func transform(input: Input, cancelBag: CancelBag) -> Output {
        let fetchedDogImage = input.didFetchButtonTapped
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .flatMap { [weak self] _ -> AnyPublisher<UIImage?, Never> in
                guard let self else { return Just(nil).eraseToAnyPublisher() }
                return self.service.fetch()
                    .eraseToAnyPublisher()
            }
            .asDriver()
        
        return Output(fetchedDogImage: fetchedDogImage)
    }
}
