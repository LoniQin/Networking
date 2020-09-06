//
//  JSON.swift
//  
//
//  Created by lonnie on 2020/8/16.
//

import Foundation

public protocol JSON: Codable, ResponseConvertable, DataConvertable {
    
}

fileprivate let jsonDecoder = JSONDecoder()

fileprivate let jsonEncoder = JSONEncoder()

extension JSON  {
    
    /// Convert to Response object
    /// - Parameter data: Data
    /// - Throws: JSONDecoder error
    /// - Returns: self
    public static func toResponse(with data: Data) throws -> Self {
        try jsonDecoder.decode(Self.self, from: data)
    }
    
    /// Convert to data
    /// - Throws: JSONEncoder error
    /// - Returns: Data
    public func toData() throws -> Data {
        try jsonEncoder.encode(self)
    }
    
}
