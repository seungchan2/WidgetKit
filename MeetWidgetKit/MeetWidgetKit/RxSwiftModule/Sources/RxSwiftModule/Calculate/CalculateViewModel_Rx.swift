//
//  CalculateViewModel_Rx.swift
//  MeetWidgetKit
//
//  Created by MEGA_Mac on 2024/06/04.
//

import Foundation

import RxSwift
import RxCocoa

import Core

public final class CalculateViewModel_Rx: ViewModelType_Rx {
    
    @Injected private var service: CalculateHelperImpl
    public var disposeBag = DisposeBag()

    public init() {}
    
    public struct Input {
        let didIncreaseButtonTapped: Observable<Operators>
        let didDecreaseButtonTapped: Observable<Operators>
    }
    public struct Output {
        let tappedCount: Driver<Int>
    }
    
    public func transform(input: Input, disposeBag: DisposeBag) -> Output {
        
        let tappedCount = BehaviorRelay(value: WidgetHelper().load())
        
        Observable.merge(input.didIncreaseButtonTapped, input.didDecreaseButtonTapped)
            .subscribe(with: self) { owner, operation in
                owner.service.calculateCount(operation: operation)
                let count = WidgetHelper().load()
                tappedCount.accept(count)
            }
            .disposed(by: self.disposeBag)
        
        return Output(tappedCount: tappedCount.asDriver(onErrorJustReturn: 0))
    }
}
