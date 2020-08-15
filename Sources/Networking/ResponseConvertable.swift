//
//  ResponseConvertable.swift
//  Prototypes
//
//  Created by lonnie on 2020/1/19.
//  Copyright © 2020 com.gtomato.enterprice. All rights reserved.
//
import Foundation
public protocol ResponseConvertable {
    static func getItem(with data: Data) throws -> Self
}

extension String: ResponseConvertable {
    
    public static func getItem(with data: Data) throws -> String {
        guard let string = String(data: data, encoding: .utf8) else {
            throw NetworkingError.codingError
        }
        return string
    }
}

extension Data: ResponseConvertable {
    public static func getItem(with data: Data) throws -> Data {
        return data
    }
}
