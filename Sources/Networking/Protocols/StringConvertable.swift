//
//  StringConvetable.swift
//  
//
//  Created by lonnie on 2020/8/16.
//

import Foundation
public protocol StringConvetable {
    
    func toString() -> String
    
}

extension String: StringConvetable {
    
    public func toString() -> String {
        self
    }
    
}
