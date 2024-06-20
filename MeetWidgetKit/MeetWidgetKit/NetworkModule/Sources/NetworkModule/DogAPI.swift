//
//  DogAPI.swift.swift
//
//
//  Created by MEGA_Mac on 2024/06/19.
//

import Moya

public enum DogAPI {
    case getDogImage
}

extension DogAPI: NetworkAPI {
    public var urlPath: String {
        return "/api/breeds/image/random"
    }
    
    public var method: Method {
        return .get
    }
}
