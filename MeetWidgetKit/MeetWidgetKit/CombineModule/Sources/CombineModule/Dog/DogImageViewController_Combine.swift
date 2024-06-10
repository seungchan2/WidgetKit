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
    
    private let originView = DogView()
    private let cancelBag = CancelBag()
    private let viewModel: DogViewModel_Combine
    
    public override func loadView() {
        self.view = originView
    }
    
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
        self.bind()
    }
   
    private func bind() {
        let input = DogViewModel_Combine.Input(didFetchButtonTapped: self.originView.fetchButtonPublisher)
        
        let output = viewModel.transform(input: input, cancelBag: self.cancelBag)
        
        output.fetchedDogImage
            .subscribe(self.originView.fetchedImagePublisher)
            .store(in: self.cancelBag)
    }
}
