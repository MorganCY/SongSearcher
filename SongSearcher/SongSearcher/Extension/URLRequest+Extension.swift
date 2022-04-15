//
//  URLRequest+Extension.swift
//  SongSearcher
//
//  Created by Zheng-Yuan Yu on 2022/3/19.
//

import Foundation

internal enum HTTPMethod: String {
    case GET
    case HEAD
    case POST
    case PUT
    case DELETE
    case PATCH
}

extension URLRequest {
    init(url: URL,
         method: HTTPMethod = .GET,
         header: [String: String] = [:],
         body: Data? = nil,
         cachePolicy: URLRequest.CachePolicy = .useProtocolCachePolicy,
         timeoutInterval: TimeInterval = 60) {
        
        self = URLRequest(url: url, cachePolicy: cachePolicy, timeoutInterval: timeoutInterval)
        httpMethod = method.rawValue
        allHTTPHeaderFields = header
        httpBody = body
    }
}
