//
//  ViewController.swift
//  MeetWidgetKit
//
//  Created by MEGA_Mac on 2024/05/29.
//

import UIKit

import RxSwift
import RxCocoa

import Core
import NetworkModule

public final class CalculateViewController_Rx: UIViewController, ViewControllable {
    private let dependencyContainer = DependencyStore.shared
    private let originView = CalculateView()
    private lazy var increaseButton = UIButton()
    private lazy var decreaseButton = UIButton()
    private lazy var transitionButton = UIButton()
    private let countLabel = UILabel()
    
    private var viewModel: CalculateViewModel_Rx
    private let disposeBag = DisposeBag()
    
    public override func loadView() {
        self.view = originView
    }
    
    public init(viewModel: CalculateViewModel_Rx) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let cancelBag = CancelBag()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setBackgroundColor()
        self.startMonitoringNetwork()
        self.action()
        self.bind()
    }
    
    private func action() {
        originView.rx.transitionButtonTapped
            .subscribe(with: self) { owner, _ in
                let viewController = owner.dependencyContainer.registerRxDogViewController()
                owner.navigationController?.pushViewController(viewController, animated: true)
            }
            .disposed(by: self.disposeBag)
    }
    
    private func bind() {
        let input = CalculateViewModel_Rx.Input(didIncreaseButtonTapped: originView.rx.increaseButtonTapped,
                                                didDecreaseButtonTapped: originView.rx.decreaseButtonTapped)
        
        let output = viewModel.transform(input: input, disposeBag: disposeBag)
        
        output.tappedCount
            .map { "\($0)" }
            .drive(originView.rx.tappedCount)
            .disposed(by: self.disposeBag)
    }
}
