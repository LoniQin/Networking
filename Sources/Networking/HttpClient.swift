//
//  NetworkManager.swift
//  Prototypes
//
//  Created by Lonnie on 13/1/2020.
//
import Foundation

public protocol Requestable {
    func send<T: ResponseConvertable>(_ request: RequestConvertable, completion: @escaping (Result<T, Error>)->Void)
}

public enum HttpMethod: String {
    
    case get
    
    case post
    
    case put
    
    case delete
    
}

public enum ContentType: String {
    
    case json = "application/json"
    
    case multipart_formdata = "multipart/form-data"
    
    case text_plain = "text/plain"
    
    case octet_stream = "application/octet-stream"
    
}

public class HttpClient: Requestable {
    
    public static let `default` = HttpClient()
    
    public let session: URLSession
    
    public init(session: URLSession = .shared) {
        self.session = session
    }
    
    var tasks: [UUID: URLSessionTask] = [:]

    public func send<T: ResponseConvertable>(
        _ request: RequestConvertable,
        completion: @escaping (Result<T, Error>)->Void
    ) {
        let requestID = UUID()
        do {
            let task = session.dataTask(with: try request.toURLRequest()) { [weak self] data, response, error in
                self?.tasks.removeValue(forKey: requestID)
                do {
                    if let error = error {
                        completion(.failure(error))
                    } else if let data = data {
                        let response = try T.toResponse(with: data)
                        completion(.success(response))
                    } else {
                        completion(.failure(NetworkingError.unknownError))
                    }
                } catch let error {
                    completion(.failure(error))
                }
            }
            task.resume()
            tasks[requestID] = task
        } catch let error {
            completion(.failure(error))
        }
    }
}
