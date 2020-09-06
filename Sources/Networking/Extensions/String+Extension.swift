//
//  String+Extension.swift
//  
//
//  Created by lonnie on 2020/9/5.
//

import Foundation
extension String {
    
    /// Return UTF8 data from String
    /// - Throws: NetworkingError.codingError
    /// - Returns: Data
    func utf8Data() throws -> Data {
        if let data = self.data(using: .utf8) {
            return data
        }
        throw NetworkingError.codingError
    }
}
