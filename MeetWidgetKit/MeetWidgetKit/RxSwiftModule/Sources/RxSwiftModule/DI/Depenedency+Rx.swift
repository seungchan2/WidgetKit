//
//  DependencyStore+Rx.swift
//  
//
//  Created by MEGA_Mac on 2024/06/07.
//

import UIKit

import Core
import NetworkModule

extension DependencyStore {
    public func registerAll() {
        register(NetworkService_Rx.shared, for: NetworkServiceRxImpl.self)
        register(NetworkService_Combine.shared, for: NetworkServiceCombineImpl.self)
        register(WidgetHelper.shared, for: ImageGeneratorImpl.self)
        register(WidgetHelper.shared, for: CalculateHelperImpl.self)
    }
    
    public func registerRxCalculateViewController() -> UIViewController {
        self.register(CalculateViewController_Rx(viewModel: CalculateViewModel_Rx()))
        return self.resolve() as CalculateViewController_Rx
    }
    
    public func registerRxDogViewController() -> UIViewController {
        self.register(DogViewController_Rx(viewModel: DogViewModel_Rx()))
        return self.resolve() as DogViewController_Rx
    }
}
