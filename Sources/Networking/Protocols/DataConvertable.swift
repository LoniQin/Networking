//
//  DataConvertable.swift
//  
//
//  Created by lonnie on 2020/8/16.
//

import Foundation

public protocol DataConvertable {
    
    /// Convert to data
    func toData() throws -> Data
    
}


extension Data: DataConvertable {
    
    public func toData() throws -> Data {
        self
    }
    
}

extension Dictionary: DataConvertable where Key: Codable, Value: Codable {
    
    public func toData() throws -> Data {
        try JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
    }
    
}
