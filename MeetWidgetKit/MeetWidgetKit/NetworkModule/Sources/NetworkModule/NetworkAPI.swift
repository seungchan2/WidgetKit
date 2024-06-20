//
//  NetworkAPI.swift
//
//
//  Created by MEGA_Mac on 2024/06/19.
//

import Foundation

import Moya

public protocol NetworkAPI: TargetType {
    var urlPath: String { get }
}

extension NetworkAPI {
    public var baseURL: URL {
        return URL(string: "https://dog.ceo")!
    }
    
    public var path: String {
        return ""
    }
    
    public var headers: [String : String]? {
        return nil
    }
    
    public var task: Task {
        return .requestPlain
    }
}
