//
//  JSONCodable.swift
//  
//
//  Created by lonnie on 2020/8/16.
//

import Foundation

public protocol JSONCodable: Codable, ResponseConvertable, DataConvertable {
    
}

extension JSONCodable  {
    
    public static func toResponse(with data: Data) throws -> Self {
        try JSONDecoder().decode(Self.self, from: data)
    }
    
    public func toData() throws -> Data {
        try JSONEncoder().encode(self)
    }
    
}
