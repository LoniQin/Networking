//
//  requests.swift
//  Prototypes
//
//  Created by lonnie on 2020/1/19.
//  Copyright © 2020 com.gtomato.enterprice. All rights reserved.
//
import Foundation
public protocol RequestConvertable {
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

extension URLRequest: RequestConvertable {
    public func toURLRequest() throws -> URLRequest {
        self
    }
}
