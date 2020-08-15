//
//  NetworkManager.swift
//  Prototypes
//
//  Created by gzuser on 13/1/2020.
//  Copyright © 2020 com.gtomato.enterprice. All rights reserved.
//
import Foundation

public protocol Requestable {
    func send<T: ResponseConvertable>(
        _ request: RequestConvertable,
        success: @escaping  (T)->Void,
        failure: @escaping (Error)->Void
    )
}

public enum HttpMethod: String {
    case get, post, put, delete
}

public enum ContentType: String {
    case json = "application/json"
    case multipart_formdata = "multipart/form-data"
    case text_plain = "text/plain"
    case octet_stream = "application/octet-stream"
}

public class HttpClient: Requestable {
    
    var tasks: [UUID: URLSessionTask] = [:]

    public func send<T: ResponseConvertable>(
        _ request: RequestConvertable,
        success: @escaping  (T)->Void,
        failure: @escaping (Error)->Void
    ) {
        let requestID = UUID()
        do {
            let task = URLSession.shared.dataTask(with: try request.toURLRequest()) { [weak self] data, response, error in
                do {
                    if let error = error {
                        failure(error)
                    } else if let data = data {
                        let response = try T.getItem(with: data)
                        success(response)
                    } else {
                        failure(NetworkingError.unknownError)
                    }
                } catch let error {
                    failure(error)
                }
                self?.tasks.removeValue(forKey: requestID)
            }
            task.resume()
            tasks[requestID] = task
        } catch let error {
            failure(error)
        }
    }
}
