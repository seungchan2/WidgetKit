//
//  NetworkService_Combine.swift
//
//
//  Created by MEGA_Mac on 2024/06/04.
//

import Combine
import UIKit

import Core

public protocol NetworkServiceCombineImpl {
    func fetch() -> Future<UIImage?, Never>
}

public final class NetworkService_Combine: NetworkServiceCombineImpl {
    public init() {}
    
    private var cancelBag = CancelBag()
    
    public func fetch() -> Future<UIImage?, Never> {
        return Future<UIImage?, Never> { promise in
            guard let url = URL(string: "https://dog.ceo/api/breeds/image/random") else {
                promise(.success(nil))
                return
            }
            URLSession.shared.dataTaskPublisher(for: url)
                .tryMap { (data, response) -> Data in
                    return data
                }
                .decode(type: DogResponseData.self, decoder: JSONDecoder())
                .compactMap { URL(string: $0.message) }
                .flatMap { imageUrl in
                    URLSession.shared.dataTaskPublisher(for: imageUrl)
                        .map { $0.data }
                        .catch { _ in Just(Data()) }
                }
                .map { UIImage(data: $0) }
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { _ in }, receiveValue: { image in
                    promise(.success(image))
                })
                .store(in: self.cancelBag)
        }
    }
}