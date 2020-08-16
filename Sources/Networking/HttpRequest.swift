//
//  HttpRequest.swift
//  
//
//  Created by lonnie on 2020/8/16.
//

import Foundation

public struct None: Codable {
    
}

public struct HttpRequest<Q: Codable, J: Codable>: RequestConvertable {
    
    public let domain: StringConvetable
    
    public let paths: [StringConvetable]
    
    public let method: HttpMethod
    
    public let queryParams: Q?
    
    public let jsonParams: J?
    
    public let headerParams: [String: String]
    
    init(domain: StringConvetable,
         paths: [StringConvetable] = [],
         method: HttpMethod = .get,
         queryParams: Q? = nil,
         jsonParams: J? = nil,
         headerParams: [String: String] = [:]) {
        self.domain = domain
        self.paths = paths
        self.method = method
        self.queryParams = queryParams
        self.jsonParams = jsonParams
        self.headerParams = headerParams
    }
    
    public func toURLRequest() throws -> URLRequest {
        var query = ""
        if let queryParams = queryParams {
            query = Mirror(reflecting: queryParams).children.map({"\($0.label ?? "")=\($0.value)"}).joined(separator: "&")
        }
        var urlString = ([domain]+paths).map({$0.toString()}).joined(separator: "/")
        if !query.isEmpty {
            urlString.append("?\(query)")
        }
        guard let url = URL(string: urlString) else { throw NetworkingError.invalidRequest }
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue.uppercased()
        if method == .post {
            request.httpBody = try JSONEncoder().encode(jsonParams)
        }
        request.allHTTPHeaderFields = headerParams
        return request
    }
}
