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
    private lazy var increaseButton = UIButton()
    private lazy var decreaseButton = UIButton()
    private lazy var transitionButton = UIButton()
    private let countLabel = UILabel()
    
    private var viewModel: CalculateViewModel_Combine
    private let cancelBag = CancelBag()
    
    public init(viewModel: CalculateViewModel_Combine) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
  
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    public override func viewDidLoad() {
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
                guard let self else { return }
                let viewController = self.dependencyContainer.registerCombineDogViewController()
                self.navigationController?.pushViewController(viewController, animated: true)
            }
            .store(in: self.cancelBag)
    }
    
    private func bind() {
        let input = CalculateViewModel_Combine.Input(didIncreaseButtonTapped: self.increaseButton.publisher(for: .touchUpInside).map { _ in .sum }.asDriver(),
                                                     didDecreaseButtonTapped: self.decreaseButton.publisher(for: .touchUpInside).map { _ in .minus }.asDriver())
        
        let output = viewModel.transform(input: input, cancelBag: cancelBag)
        
        output.tappedCount
            .sink { [weak self] count in
                self?.countLabel.text = "\(count)"
            }
            .store(in: self.cancelBag)
    }
}

private extension CalculateViewController_Combine {
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
