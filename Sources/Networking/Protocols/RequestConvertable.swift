//
//  RequestConvertable.swift
//
//
//  Created by lonnie on 2020/1/19.
//
import Foundation

public protocol RequestConvertable {
    
    /// Convert to URLRequest instance
    func toURLRequest() throws -> URLRequest
    
}

extension String: RequestConvertable {
    
    public func toURLRequest() throws -> URLRequest {
        guard let url = URL(string: self)  else {
            throw NetworkingError.invalidRequest
        }
        return URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: 30)
    }
    
}

extension URL: RequestConvertable {
    
    public func toURLRequest() throws -> URLRequest {
        URLRequest(url: self, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: 30)
    }
    
}

extension URLRequest: RequestConvertable {
    
    public func toURLRequest() throws -> URLRequest {
        self
    }
    
}
