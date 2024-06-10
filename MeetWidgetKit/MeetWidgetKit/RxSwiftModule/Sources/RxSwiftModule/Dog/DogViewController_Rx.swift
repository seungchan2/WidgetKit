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
    private lazy var imageView = UIImageView()
    private lazy var fetchButton = UIButton()
    private let disposeBag = DisposeBag()

    private let viewModel: DogViewModel_Rx
    
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
        self.setStyle()
        self.setLayout()
        self.bind()
    }
    
    private func bind() {
        let input = DogViewModel_Rx.Input(didFetchButtonTapped: self.fetchButton.rx.tap.asObservable())
        
        let output = viewModel.transform(input: input, disposeBag: self.disposeBag)
        
        output.fetchedDogImage
            .drive(with: self) { owner, image in
                owner.imageView.image = image
            }
            .disposed(by: self.disposeBag)
    }
}

private extension DogViewController_Rx {
    func setStyle() {
        self.fetchButton.backgroundColor = .black
        self.fetchButton.setTitle("이미지 생성", for: .normal)
        self.imageView.backgroundColor = .cyan
        self.imageView.image = WidgetHelper().loadImage()
    }
    
    func setLayout() {
        self.view.addSubview(self.imageView)
        self.imageView.translatesAutoresizingMaskIntoConstraints = false
        self.imageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.imageView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        self.imageView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        self.imageView.widthAnchor.constraint(equalToConstant: 200).isActive = true
        
        self.view.addSubview(self.fetchButton)
        self.fetchButton.translatesAutoresizingMaskIntoConstraints = false
        self.fetchButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -50).isActive = true
        self.fetchButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
        self.fetchButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).isActive = true
        self.fetchButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
}
