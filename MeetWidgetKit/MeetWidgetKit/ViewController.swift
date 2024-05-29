//
//  ViewController.swift
//  MeetWidgetKit
//
//  Created by MEGA_Mac on 2024/05/29.
//

import Combine
import UIKit

final class ViewController: UIViewController, ViewControllable {
    private lazy var increaseButton = UIButton()
    private lazy var decreaseButton = UIButton()
    
    private let widgetService: WidgetHelperImpl
    
    init(widgetService: WidgetHelperImpl) {
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
        increaseButton.publisher(for: .touchUpInside)
            .sink { [weak self] _ in
                self?.widgetService.incrementCount(kind: .increase)
            }
            .store(in: self.cancelBag)
        
        decreaseButton.publisher(for: .touchUpInside)
            .sink { [weak self] _ in
                self?.widgetService.decrementCount(kind: .increase)
            }
            .store(in: self.cancelBag)
    }
}

private extension ViewController {
    func setStyle() {
        self.view.addSubview(self.increaseButton)
        self.increaseButton.backgroundColor = .red
        
        self.view.addSubview(self.decreaseButton)
        self.decreaseButton.backgroundColor = .blue
    }
    
    func setLayout() {
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
    }
}
