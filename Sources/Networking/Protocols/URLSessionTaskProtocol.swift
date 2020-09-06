//
//  URLSessionTaskProtocol.swift
//  
//
//  Created by lonnie on 2020/9/6.
//

import Foundation

public protocol URLSessionTaskProtocol: Resumable, Cancellable, Suspendable {
    
}
extension URLSessionTask: URLSessionTaskProtocol {
    
}
