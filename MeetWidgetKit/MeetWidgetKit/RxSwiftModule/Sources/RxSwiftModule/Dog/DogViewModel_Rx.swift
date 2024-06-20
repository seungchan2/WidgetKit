//
//  DogViewModel_Rx.swift
//
//
//  Created by MEGA_Mac on 2024/06/04.
//

import UIKit

import Core
import NetworkModule

import ChanLog
import RxSwift
import RxCocoa

public final class DogViewModel_Rx: ViewModelType_Rx {
    
    public var disposeBag = DisposeBag()
    // MARK: DogRandomAPI 네트워크 protocol
    @Injected private var service: NetworkServiceRxImpl
    @Injected private var moyaService: DogServiceType

    public init() {}
    public struct Input {
        let didFetchButtonTapped: Observable<Void>
    }
    
    public struct Output {
        let fetchedDogImage: Driver<UIImage?>
    }
    
    public func transform(input: Input, disposeBag: DisposeBag) -> Output {
        
        // MARK: ViewController fetchButton 이벤트 시, API 호출 (throttle로 중복 제거)
        let dogImage = input.didFetchButtonTapped
            .debounce(.milliseconds(300), scheduler: MainScheduler.instance)
            .flatMapLatest { [weak self] _ -> Single<UIImage?> in
                guard let self else { return Single.just(nil) }
                return self.service.fetch()
            }
            .asDriver(onErrorJustReturn: UIImage(named: "heart.fill"))
        
        moyaService
            .getDogImage()
            .subscribe(with: self) { owner, data in
                ChanLog.custom(category: "Network",
                               "RxMoya를 사용한 강아지 이미지 가져오기", 
                               data.message)
                ChanLog.custom(category: "Network",
                               "RxMoya를 사용한 강아지 이미지 가져오기",
                               data.status)
            }
            .disposed(by: self.disposeBag)
        
        
        return Output(fetchedDogImage: dogImage)
    }
}
