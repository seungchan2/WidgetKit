//
//  CalculateView.swift
//
//
//  Created by MEGA_Mac on 2024/06/10.
//

import Combine
import UIKit

import RxSwift
import RxCocoa

public final class CalculateView: UIView {
    fileprivate lazy var increaseButton = UIButton()
    fileprivate lazy var decreaseButton = UIButton()
    fileprivate lazy var transitionButton = UIButton()
    fileprivate let countLabel = UILabel()
    private let cancelBag = CancelBag()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.setStyle()
        self.setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Rx ViewController에서 사용할 이벤트 정의 protection level -> fileprivate
extension Reactive where Base: CalculateView {
    public var increaseButtonTapped: Observable<Operators> {
        return base.increaseButton.rx.tap
            .map { Operators.sum }
    }
    
    public var decreaseButtonTapped: Observable<Operators> {
        return base.decreaseButton.rx.tap
            .map { Operators.minus }
    }
    
    public var transitionButtonTapped: Observable<Void> {
        return base.transitionButton.rx.tap.asObservable()
    }
    
    public var tappedCount: Binder<String?> {
        return base.countLabel.rx.text
    }
}

// MARK: Combine
extension CalculateView {
    public var increaseButtonPublisher: AnyPublisher<Operators, Never> {
        increaseButton.publisher(for: .touchUpInside)
            .map { _ in Operators.sum }
            .eraseToAnyPublisher()
    }

    public var decreaseButtonPublisher: AnyPublisher<Operators, Never> {
        decreaseButton.publisher(for: .touchUpInside)
            .map { _ in Operators.minus }
            .eraseToAnyPublisher()
    }

    public var transitionButtonPublisher: AnyPublisher<Void, Never> {
        transitionButton.publisher(for: .touchUpInside)
            .map { _ in }
            .eraseToAnyPublisher()
    }

    public var countLabelText: PassthroughSubject<String?, Never> {
        let subject = PassthroughSubject<String?, Never>()
        subject.sink { [weak self] text in
            guard let self else { return }
            self.countLabel.text = text
        }
        .store(in: self.cancelBag)
        return subject
    }
}

private extension CalculateView {
    func setStyle() {
        self.increaseButton.backgroundColor = .red
        self.increaseButton.setTitle("+", for: .normal)
        self.decreaseButton.backgroundColor = .blue
        self.decreaseButton.setTitle("-", for: .normal)
        self.transitionButton.backgroundColor = .black
        self.transitionButton.setTitle("다음으로", for: .normal)
    }
    
    func setLayout() {
        self.addSubview(self.increaseButton)
        self.addSubview(self.decreaseButton)
        self.addSubview(self.transitionButton)
        self.addSubview(self.countLabel)
        
        self.increaseButton.translatesAutoresizingMaskIntoConstraints = false
        self.increaseButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 50).isActive = true
        self.increaseButton.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        self.increaseButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        self.increaseButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        self.decreaseButton.translatesAutoresizingMaskIntoConstraints = false
        self.decreaseButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -50).isActive = true
        self.decreaseButton.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        self.decreaseButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        self.decreaseButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        self.transitionButton.translatesAutoresizingMaskIntoConstraints = false
        self.transitionButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
        self.transitionButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20).isActive = true
        self.transitionButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -50).isActive = true
        self.transitionButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        self.countLabel.translatesAutoresizingMaskIntoConstraints = false
        self.countLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        self.countLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
    }
}
