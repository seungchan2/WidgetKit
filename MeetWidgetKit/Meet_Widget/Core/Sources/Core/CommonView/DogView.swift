//
//  DogView.swift
//
//
//  Created by MEGA_Mac on 2024/06/10.
//

import Combine
import UIKit

import RxSwift
import RxCocoa
 
public final class DogView: UIView {
    fileprivate lazy var imageView = UIImageView()
    fileprivate lazy var fetchButton = UIButton()
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

extension Reactive where Base: DogView {
    public var fetchButtonTapped: Observable<Void> {
        return base.fetchButton.rx.tap.asObservable()
    }
    
    public var fetchedDogImage: Binder<UIImage?> {
        return base.imageView.rx.image
    }
}

extension DogView {
    public var fetchButtonPublisher: AnyPublisher<Void, Never> {
        fetchButton.publisher(for: .touchUpInside)
            .map { _ in }
            .eraseToAnyPublisher()
    }
    
    public var fetchedImagePublisher: PassthroughSubject<UIImage?, Never> {
        let subject = PassthroughSubject<UIImage?, Never>()
        subject.sink { [weak self] image in
            guard let self else { return }
            self.imageView.image = image
        }
        .store(in: self.cancelBag)
        return subject
    }
}

private extension DogView {
    func setStyle() {
        self.fetchButton.backgroundColor = .black
        self.fetchButton.setTitle("이미지 생성", for: .normal)
        self.imageView.backgroundColor = .cyan
        self.imageView.image = WidgetHelper().loadImage()
    }
    
    func setLayout() {
        self.addSubview(self.imageView)
        self.imageView.translatesAutoresizingMaskIntoConstraints = false
        self.imageView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        self.imageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        self.imageView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        self.imageView.widthAnchor.constraint(equalToConstant: 200).isActive = true
        
        self.addSubview(self.fetchButton)
        self.fetchButton.translatesAutoresizingMaskIntoConstraints = false
        self.fetchButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -50).isActive = true
        self.fetchButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
        self.fetchButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20).isActive = true
        self.fetchButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
}
