//
//  HttpClient.swift
//  
//
//  Created by Lonnie on 13/1/2020.
//
import Foundation

public class HttpClient: Requestable {
    
    public static let `default` = HttpClient()
    
    public let session: URLSession
    
    public let queue: DispatchQueue
    
    /// Init method
    /// - Parameters:
    ///   - session: URLSession, default is shared
    ///   - queue: Dispatch queue
    public init(session: URLSession = .shared, queue: DispatchQueue = .main) {
        self.session = session
        self.queue = queue
    }

    @discardableResult
    public func send<T: ResponseConvertable>(
        _ request: RequestConvertable,
        completion: @escaping (Result<T, Error>)->Void
    ) -> URLSessionTaskProtocol? {
        do {
            let task = session.dataTask(with: try request.toURLRequest()) { [weak self] data, response, error in
                guard let data = data else {
                    self?.dispatch(completion: completion, result: .failure(error ?? NetworkingError.unknownError))
                    return
                }
                do {
                    let response = try T.toResponse(with: data)
                    self?.dispatch(completion: completion, result: .success(response))
                } catch let error {
                    self?.dispatch(completion: completion, result: .failure(error))
                }
            }
            task.resume()
            return task
        } catch let error {
            dispatch(completion: completion, result: .failure(error))
            return nil
        }
    }
    
    private func dispatch<T>(completion: @escaping (Result<T, Error>)->Void, result: Result<T, Error>) {
        queue.async {
            completion(result)
        }
    }
    
}
