//
//  CalculateViewModel_Combine.swift
//  MeetWidgetKit
//
//  Created by MEGA_Mac on 2024/06/04.
//

import Combine
import Foundation

import Core

public final class CalculateViewModel_Combine: ViewModelType_Combine {
    
    private var service: CalculateHelperImpl
    public var cancelBag = CancelBag()

    public init(service: CalculateHelperImpl) {
        self.service = service
    }
    
    public struct Input {
        let didIncreaseButtonTapped: AnyPublisher<OP, Never>
        let didDecreaseButtonTapped: AnyPublisher<OP, Never>
    }
    public struct Output {
        let tappedCount: CombineDriver<Int>
    }
    
    public func transform(input: Input, cancelBag: CancelBag) -> Output {
        let tappedCount = CurrentValueSubject<Int, Never>(WidgetHelper().load())

        let mergedPublisher = input.didIncreaseButtonTapped
            .merge(with: input.didDecreaseButtonTapped)
          
          mergedPublisher
            .asDriver()
            .sink { [weak self] operation in
                guard let self else { return }
                let currentCount = WidgetHelper().load()
                self.service.calculateCount(operation: operation)
                tappedCount.send(currentCount)
            }
              .store(in: self.cancelBag)
          
        return Output(tappedCount: tappedCount.asDriver())
      }
}
