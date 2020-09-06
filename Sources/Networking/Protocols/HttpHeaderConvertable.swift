//
//  HttpHeaderConvertable.swift
//  
//
//  Created by lonnie on 2020/9/6.
//

import Foundation
public protocol HttpHeaderConvertable {
    
    /// Convert to HTTP Header
    func toHttpHeader() -> [String: String]
}

extension Dictionary: HttpHeaderConvertable where Key == String, Value == String {
    
    public func toHttpHeader() -> [String : String] {
        return self
    }
    
}
