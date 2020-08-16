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
    
    public let queue: DispatchQueue
    
    public init(session: URLSession = .shared, queue: DispatchQueue = .main) {
        self.session = session
        self.queue = queue
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
                    if let data = data {
                        let response = try T.toResponse(with: data)
                        self?.dispatch(completion: completion, result: .success(response))
                    } else {
                        self?.dispatch(completion: completion, result: .failure(error ?? NetworkingError.unknownError))
                    }
                } catch let error {
                    self?.dispatch(completion: completion, result: .failure(error))
                }
            }
            task.resume()
            tasks[requestID] = task
        } catch let error {
            dispatch(completion: completion, result: .failure(error))
        }
    }
    
    private func dispatch<T>(completion: @escaping (Result<T, Error>)->Void, result: Result<T, Error>) {
        queue.async {
            completion(result)
        }
    }
}
