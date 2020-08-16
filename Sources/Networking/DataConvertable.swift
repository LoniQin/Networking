//
//  DataConvertable.swift
//  
//
//  Created by lonnie on 2020/8/16.
//

import Foundation

public protocol DataConvertable {
    func toData() throws -> Data
}


extension Data: DataConvertable {
    public func toData() throws -> Data {
        self
    }
}


