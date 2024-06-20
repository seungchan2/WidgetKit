//
//  DogService.swift
//
//
//  Created by MEGA_Mac on 2024/06/19.
//

import RxSwift
import RxCocoa

import Moya

import Foundation

public protocol DogServiceType {
    func getDogImage() -> Observable<DogResponseData>
}

public final class DogService: DogServiceType {

    private let disposeBag = DisposeBag()
    
    private let provider = NetworkProvider<DogAPI>()
    public static let shared = DogService()

    public init() {}
    
    public func getDogImage() -> Observable<DogResponseData> {
        return provider.request(.getDogImage)
            .map(DogResponseData.self)
            .asObservable()
    }
}

extension PrimitiveSequence where Trait == SingleTrait, Element == Moya.Response {

    public var decoder: JSONDecoder {
        let decoder = JSONDecoder()
        return decoder
    }

    /// Wrap to common response
    /// - Common response로 감싼 객체로 매핑해주는 메소드
    func map<Response: Decodable>(
        _ type: Response.Type
    ) -> PrimitiveSequence<Trait, BaseResponse<Response>> {
        return map(BaseResponse<Response>.self, using: decoder)
    }

    /// Map to pure
    /// - Pure data로 매핑해주는 메소드(아래 설명 참조)
    /// - 옵셔널 타입으로 반환합니다.
    public func map<Response: Decodable>(
        _ type: Response.Type
    ) -> PrimitiveSequence<Trait, Response?> {
        return map(BaseResponse.self).map { $0.data }
    }
}

public struct BaseResponse<R>: Decodable where R: Decodable {
    public let data: R?
}
