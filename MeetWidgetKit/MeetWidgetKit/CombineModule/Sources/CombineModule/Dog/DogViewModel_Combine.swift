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
    
    public var cancelBag = CancelBag()
    private let service: NetworkServiceCombineImpl
    
    public init(service: NetworkServiceCombineImpl) {
        self.service = service
    }
    
    public struct Input {
        let didFetchButtonTapped: AnyPublisher<Void, Never>
    }
    
    public struct Output {
        let fetchedDogImage: CombineDriver<UIImage?>
    }
    
    public func transform(input: Input, cancelBag: CancelBag) -> Output {
        let fetchedDogImage = input.didFetchButtonTapped
            .flatMap { [weak self] _ -> AnyPublisher<UIImage?, Never> in
                guard let self = self else { return Just(nil).eraseToAnyPublisher() }
                return self.service.fetch()
                    .asDriver()
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
        
        return Output(fetchedDogImage: fetchedDogImage)
    }
}
