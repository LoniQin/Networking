//
//  HttpRequest.swift
//  
//
//  Created by lonnie on 2020/8/16.
//

import Foundation

public struct HttpRequest: RequestConvertable {
    
    public let domain: StringConvetable
    
    public let paths: [StringConvetable]
    
    public let method: HttpMethod
    
    public let query: [String: String]
    
    public let body: DataConvertable?
    
    public let header: [String: String]
    
    init(domain: StringConvetable,
         paths: [StringConvetable] = [],
         method: HttpMethod = .get,
         query: [String: String] = [:],
         body: DataConvertable? = nil,
         header: [String: String] = [:]) {
        self.domain = domain
        self.paths = paths
        self.method = method
        self.query = query
        self.body = body
        self.header = header
    }
    
    public func toURLRequest() throws -> URLRequest {
        var queryPart = ""
        if !query.isEmpty {
            queryPart = query.sorted(by: {$0.key < $1.key})
                .map({"\($0.key)=\($0.value)"}).joined(separator: "&")
        }
        var urlString = ([domain]+paths).map({$0.toString()}).joined(separator: "/")
        if !queryPart.isEmpty {
            urlString.append("?\(queryPart)")
        }
        guard let url = URL(string: urlString) else { throw NetworkingError.invalidRequest }
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue.uppercased()
        if let body = body {
            request.httpBody = try body.toData()
        }
        request.allHTTPHeaderFields = header
        return request
    }
    
}
