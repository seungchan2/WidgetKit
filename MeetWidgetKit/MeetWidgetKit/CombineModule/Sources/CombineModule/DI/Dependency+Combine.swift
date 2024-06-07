//
//  DependencyStore+Combine.swift
//  
//
//  Created by MEGA_Mac on 2024/06/07.
//

import UIKit

import NetworkModule
import Core

extension DependencyStore {
    public func registerCombineViewController() -> UIViewController {
        self.register { CalculateViewController_Combine(viewModel: CalculateViewModel_Combine()) }
        return self.resolve() as CalculateViewController_Combine
    }
    
    public func registerCombineDogViewController() -> UIViewController {
        self.register { DogImageViewController_Combine(viewModel: DogViewModel_Combine()) }
        return self.resolve() as DogImageViewController_Combine
    }
}
