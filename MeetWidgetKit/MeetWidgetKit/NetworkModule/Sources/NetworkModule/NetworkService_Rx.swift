//
//  NetworkService_Rx.swift
//
//
//  Created by MEGA_Mac on 2024/06/04.
//

import UIKit

import Core

import RxSwift
import RxCocoa

public protocol NetworkServiceRxImpl {
    func fetch() -> Single<UIImage?>
}

public final class NetworkService_Rx: NetworkServiceRxImpl {
    public init() {}
    
    public func fetch() -> Single<UIImage?> {
        guard let url = URL(string: "https://dog.ceo/api/breeds/image/random") else {
            return Single.just(nil)
        }
        
        return URLSession.shared.rx.data(request: URLRequest(url: url))
            .map { data -> DogResponseData in
                let decoder = JSONDecoder()
                return try decoder.decode(DogResponseData.self, from: data)
            }
            .compactMap { URL(string: $0.message) }
            .flatMap { imageUrl -> Observable<Data> in
                return URLSession.shared.rx.data(request: URLRequest(url: imageUrl))
                    .catchAndReturn(Data())
            }
            .map { UIImage(data: $0) }
            .catchAndReturn(nil)
            .asSingle()
    }
}