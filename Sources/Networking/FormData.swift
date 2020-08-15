//
//  FormData.swift
//  Prototypes
//
//  Created by lonnie on 2020/2/9.
//
import Foundation
public struct FormData: RequestConvertable  {
    
    public enum Value {
        
        case data(data: Data, contentType: ContentType, fileName: String)
        
        case string(_ value: String)
        
    }
    
    public struct Item {
        
        public let key: String
        
        public let value: Value
        
    }
    
    public let domain: String
    
    public var paths: [String]
    
    public var items: [Item]
    
    static let kContentType = "Content-Type"
    
    static let seperator = "\r\n"
    
    public func toURLRequest() throws -> URLRequest {
        var components = [domain] + paths
        guard let url = URL(string: components.joined(separator: "/")) else {
            throw NetworkingError.invalidRequest
        }
        var req = URLRequest(url: url)
        let boundary = UUID().uuidString
        var data = Data()
        data.append("--\(boundary)\(Self.seperator)".data(using: .utf8)!)
        for item in self.items {
            data.append("Content-Disposition:form-data; name=\"\(item.key)\"".data(using: .utf8)!)
            switch item.value {
            case .string(let value):
                data.append("\(Self.seperator)\(Self.seperator)\(value)".data(using: .utf8)!)
            case .data(let d, let contentType, let filename):
                data.append("; filename=\"\(filename)\"\(Self.seperator)".data(using: .utf8)!)
                data.append("\(Self.kContentType): \(contentType.rawValue)\(Self.seperator)\(Self.seperator)".data(using: .utf8)!)
                data.append(d)
                data.append(Self.seperator.data(using: .utf8)!)
            }
        }
        data.append("--\(boundary)--\(Self.seperator)".data(using: .utf8)!)
        req.httpMethod = "POST"
        req.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: Self.kContentType)
        req.httpBody = data
        return req
    }
}

