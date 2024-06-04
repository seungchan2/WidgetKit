//
//  ImageViewController_Combine.swift
//
//
//  Created by MEGA_Mac on 2024/06/04.
//

import Combine
import UIKit

import Core
import NetworkModule

public final class DogImageViewController_Combine: UIViewController, ViewControllable {
    private lazy var imageView = UIImageView()
    private lazy var fetchButton = UIButton()
    private let cancelBag = CancelBag()

    private let viewModel: DogViewModel_Combine
    
    public init(viewModel: DogViewModel_Combine) {
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
        let input = DogViewModel_Combine.Input(didFetchButtonTapped: self.fetchButton.publisher(for: .touchUpInside).mapVoid().eraseToAnyPublisher())
        
        let output = viewModel.transform(input: input, cancelBag: self.cancelBag)
        
        output.fetchedDogImage
            .sink { [weak self] image in
                guard let self else { return }
                self.imageView.image = image
            }
            .store(in: self.cancelBag)
    }
}

private extension DogImageViewController_Combine {
    func setStyle() {
        self.fetchButton.backgroundColor = .yellow
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
