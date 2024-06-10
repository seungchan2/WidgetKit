//
//  ImageViewController.swift
//  MeetWidgetKit
//
//  Created by MEGA_Mac on 2024/05/30.
//

import UIKit

import Core
import NetworkModule

import RxSwift
import RxCocoa

public final class DogViewController_Rx: UIViewController, ViewControllable {
   
    private let disposeBag = DisposeBag()
    private let originView = DogView()
    private let viewModel: DogViewModel_Rx
    
    public override func loadView() {
        self.view = originView
    }
    
    public init(viewModel: DogViewModel_Rx) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setBackgroundColor()
        self.bind()
    }
    
    private func bind() {
        let input = DogViewModel_Rx.Input(didFetchButtonTapped: self.originView.rx.fetchButtonTapped)
        
        let output = viewModel.transform(input: input, disposeBag: self.disposeBag)
        
        output.fetchedDogImage
            .drive(originView.rx.fetchedDogImage)
            .disposed(by: self.disposeBag)
    }
}
