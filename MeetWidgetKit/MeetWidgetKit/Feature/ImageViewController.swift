//
//  ImageViewController.swift
//  MeetWidgetKit
//
//  Created by MEGA_Mac on 2024/05/30.
//

import Combine
import UIKit

import Core
import NetworkModule

public final class ImageViewController: UIViewController, ViewControllable {
    private lazy var imageView = UIImageView()
    private lazy var fetchButton = UIButton()
    private let cancelBag = CancelBag()

    private let imageService: DogImageHelperImpl
    
    public init(imageService: DogImageHelperImpl) {
        self.imageService = imageService
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
        self.action()
    }
    
    private func action() {
        self.fetchButton
            .publisher(for: .touchUpInside)
            .debounce(for: 0.5, scheduler: RunLoop.main)
            .sink { _ in
                self.fetch()
            }
            .store(in: self.cancelBag)
    }
    
    private func fetch() {
        guard let url = URL(string: "https://dog.ceo/api/breeds/image/random") else { return }
        
        URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { (data, response) -> Data in
                return data
            }
            .decode(type: DogImage.self, decoder: JSONDecoder())
            .compactMap { URL(string: $0.message) }
            .flatMap { imageUrl in
                URLSession.shared.dataTaskPublisher(for: imageUrl)
                    .map { $0.data }
                    .catch { _ in Just(Data()) }
            }
            .map { UIImage(data: $0) }
            .replaceError(with: nil)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] image in
                guard let self, let image else { return }
                self.imageView.image = image
                self.imageService.save(image: image, kind: .image)
            }
            .store(in: self.cancelBag)
    }
}

private extension ImageViewController {
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
