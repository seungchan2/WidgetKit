//
//  CalculateViewController_Combine.swift
//  MeetWidgetKit
//
//  Created by MEGA_Mac on 2024/06/04.
//

import Combine
import UIKit

import Core
import NetworkModule

public final class CalculateViewController_Combine: UIViewController, ViewControllable {
    
    private let dependencyContainer = DependencyStore.shared
    private let originView = CalculateView()
    
    private var viewModel: CalculateViewModel_Combine
    private let cancelBag = CancelBag()
    
    public override func loadView() {
        self.view = originView
    }
    public init(viewModel: CalculateViewModel_Combine) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setBackgroundColor()
        self.startMonitoringNetwork()
        self.action()
        self.bind()
    }
    
    private func action() {
        originView.transitionButtonPublisher
            .sink { [weak self] _ in
                guard let self else { return }
                let viewController = self.dependencyContainer.registerCombineDogViewController()
                self.navigationController?.pushViewController(viewController, animated: true)
            }
            .store(in: self.cancelBag)
    }
    
    private func bind() {
        let input = CalculateViewModel_Combine.Input(didIncreaseButtonTapped: self.originView.increaseButtonPublisher,
                                                     didDecreaseButtonTapped: self.originView.decreaseButtonPublisher)
        
        let output = viewModel.transform(input: input, cancelBag: cancelBag)
        
        output.tappedCount
            .map { "\($0)" }
            .subscribe(originView.countLabelText)
            .store(in: self.cancelBag)
    }
}
