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
    
    // MARK: 위젯에 보여줄 카운트 저장 protocol
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
        
        // MARK: 앱을 종료하고 실행해도 카운트를 보여주기 위해 load() 호출
        let tappedCount = BehaviorRelay(value: WidgetHelper().load())
        
        /*
         +, _ 버튼 이벤트를 합쳐서 처리 (+ -> +1, - -> -1)
         */
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
