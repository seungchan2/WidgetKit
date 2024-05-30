//
//  ViewController.swift
//  MeetWidgetKit
//
//  Created by MEGA_Mac on 2024/05/29.
//

import Combine
import UIKit

final class CalculateViewController: UIViewController, ViewControllable {
    
    private lazy var increaseButton = UIButton()
    private lazy var decreaseButton = UIButton()
    private lazy var transitionButton = UIButton()
    private let widgetService: CalculateHelperImpl
    
    init(widgetService: CalculateHelperImpl) {
        self.widgetService = widgetService
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
    }
    
    private func action() {
        increaseButton
            .publisher(for: .touchUpInside)
            .sink { [weak self] _ in
                self?.widgetService.calculateCount(operation: .sum)
            }
            .store(in: self.cancelBag)
        
        decreaseButton
            .publisher(for: .touchUpInside)
            .sink { [weak self] _ in
                self?.widgetService.calculateCount(operation: .minus)
            }
            .store(in: self.cancelBag)
        
        transitionButton
            .publisher(for: .touchUpInside)
            .sink { [weak self] _ in
                let viewController = ImageViewController(imageService: WidgetHelper())
                self?.navigationController?.pushViewController(viewController, animated: true)
            }
            .store(in: self.cancelBag)
    }
}

private extension CalculateViewController {
    func setStyle() {
        self.increaseButton.backgroundColor = .red
        self.decreaseButton.backgroundColor = .blue
        self.transitionButton.backgroundColor = .white
    }
    
    func setLayout() {
        self.view.addSubview(self.increaseButton)
        self.view.addSubview(self.decreaseButton)
        self.view.addSubview(self.transitionButton)
        
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
    }
}
