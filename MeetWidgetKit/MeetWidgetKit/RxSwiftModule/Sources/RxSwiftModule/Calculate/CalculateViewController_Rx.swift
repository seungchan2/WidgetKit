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

final class CalculateViewController_Rx: UIViewController, ViewControllable {
    
    private lazy var increaseButton = UIButton()
    private lazy var decreaseButton = UIButton()
    private lazy var transitionButton = UIButton()
    private let countLabel = UILabel()
    
    private var viewModel: CalculateViewModel_Rx
    private let disposeBag = DisposeBag()
    
    init(viewModel: CalculateViewModel_Rx) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
  
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let cancelBag = CancelBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setStyle()
        self.setBackgroundColor()
        self.setLayout()
        self.startMonitoringNetwork()
        self.action()
        self.bind()
    }
    
    private func action() {

        transitionButton
            .publisher(for: .touchUpInside)
            .sink { [weak self] _ in
                let viewController = DogViewController_Rx(viewModel: DogViewModel_Rx(service: NetworkService_Rx()))
                self?.navigationController?.pushViewController(viewController, animated: true)
            }
            .store(in: self.cancelBag)
    }
    
    private func bind() {
        let input = CalculateViewModel_Rx.Input(didIncreaseButtonTapped: increaseButton.rx.tap.asObservable().map { .sum },
                                                didDecreaseButtonTapped: decreaseButton.rx.tap.asObservable().map { .minus })
        
        let output = viewModel.transform(input: input, disposeBag: disposeBag)
        
        output.tappedCount
            .drive(with: self) { owner, count in
                owner.countLabel.text = "\(count)"
            }
            .disposed(by: self.disposeBag)
    }
}

private extension CalculateViewController_Rx {
    func setStyle() {
        self.increaseButton.backgroundColor = .red
        self.decreaseButton.backgroundColor = .blue
        self.transitionButton.backgroundColor = .green
    }
    
    func setLayout() {
        self.view.addSubview(self.increaseButton)
        self.view.addSubview(self.decreaseButton)
        self.view.addSubview(self.transitionButton)
        self.view.addSubview(self.countLabel)
        
        self.increaseButton.translatesAutoresizingMaskIntoConstraints = false
        self.increaseButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 50).isActive = true
        self.increaseButton.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        self.increaseButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        self.increaseButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        self.decreaseButton.translatesAutoresizingMaskIntoConstraints = false
        self.decreaseButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -50).isActive = true
        self.decreaseButton.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        self.decreaseButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        self.decreaseButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        self.transitionButton.translatesAutoresizingMaskIntoConstraints = false
        self.transitionButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
        self.transitionButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).isActive = true
        self.transitionButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -50).isActive = true
        self.transitionButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        self.countLabel.translatesAutoresizingMaskIntoConstraints = false
        self.countLabel.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        self.countLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
    }
}