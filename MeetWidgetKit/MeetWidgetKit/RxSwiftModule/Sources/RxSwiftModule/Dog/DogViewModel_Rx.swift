//
//  DogViewModel_Rx.swift
//
//
//  Created by MEGA_Mac on 2024/06/04.
//

import UIKit

import Core
import NetworkModule

import RxSwift
import RxCocoa

public final class DogViewModel_Rx: ViewModelType_Rx {
    
    public var disposeBag = DisposeBag()
    private let service: NetworkServiceRxImpl
    
    
    public init(service: NetworkServiceRxImpl) {
        self.service = service
    }
    
    public struct Input {
        let didFetchButtonTapped: Observable<Void>
    }
    
    public struct Output {
        let fetchedDogImage: Driver<UIImage?>
    }
    
    public func transform(input: Input, disposeBag: DisposeBag) -> Output {
        
        let dogImage = input.didFetchButtonTapped
            .debounce(.milliseconds(300), scheduler: MainScheduler.instance)
            .flatMapLatest { [weak self] _ -> Single<UIImage?> in
                guard let self else { return Single.just(nil) }
                return self.service.fetch()
            }
            .asDriver(onErrorJustReturn: UIImage(named: "heart.fill"))
        
        return Output(fetchedDogImage: dogImage)
    }
}
