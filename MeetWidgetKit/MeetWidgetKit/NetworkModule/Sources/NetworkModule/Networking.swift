//
//  Networking.swift
//
//
//  Created by MEGA_Mac on 2024/06/19.
//

import Foundation

import Moya
import RxMoya
import RxSwift

protocol NetworkType {
    associatedtype API: NetworkAPI
    
    func request(_ api: API,
                 file: StaticString,
                 function: StaticString,
                 line: UInt) -> Single<Response>
}

extension NetworkType {
    func request(_ api: API,
                 file: StaticString,
                 function: StaticString,
                 line: UInt) -> Single<Response> {
        self.request(api, file: file, function: function, line: line)
    }
}

final class NetworkProvider<API: NetworkAPI>: NetworkType {
    private let provider: MoyaProvider<API>
    private let disposeBag = DisposeBag()
    
    init(plugins: [PluginType] = []) {
        self.provider = MoyaProvider(plugins: plugins)
    }
    
    func request(
        _ api: API,
        file: StaticString = #file,
        function: StaticString = #function,
        line: UInt = #line
    ) -> Single<Response> {
        let requestString = "\(api.urlPath)"
        
        return provider.rx.request(api)
            .filterSuccessfulStatusCodes()
            .do(
                onSuccess: { response in
                    print("SUCCESS: \(requestString) (\(response.statusCode))")
                },
                onError: { _ in
                    print("ERROR: \(requestString)")
                },
                onSubscribed: {
                    print("REQUEST: \(requestString)")
                }
            )
    }
}
