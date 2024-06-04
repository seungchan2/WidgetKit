//
//  File.swift
//  MeetWidgetKit
//
//  Created by MEGA_Mac on 2024/06/04.
//

import Foundation

import Core

public protocol ViewModelType_Combine {
    associatedtype Input
    associatedtype Output
    var cancelBag: CancelBag { get }
    
    func transform(input: Input, cancelBag: CancelBag) -> Output
}
