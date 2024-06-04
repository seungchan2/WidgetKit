//
//  RxViewModelType.swift
//  MeetWidgetKit
//
//  Created by MEGA_Mac on 2024/06/04.
//

import Foundation

import RxSwift
import RxCocoa

public protocol ViewModelType_Rx {
    associatedtype Input
    associatedtype Output
    var disposeBag: DisposeBag { get }
    
    func transform(input: Input, disposeBag: DisposeBag) -> Output
}
