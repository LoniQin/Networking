//
//  Form.swift
//
//
//  Created by lonnie on 2020/2/9.
//
import Foundation

/// Form
public struct Form: RequestConvertable  {
    
    public enum Value {
        
        case data(data: Data, contentType: ContentType, fileName: String)
        
        case string(_ value: String)
        
    }
    
    public struct Item {
        
        public let key: String
        
        public let value: Value
        
        public init(key: String, value: Value) {
            self.key = key
            self.value = value
        }
        
    }
    
    public let domain: StringConvetable
    
    public var paths: [StringConvetable]
    
    public var items: [Item]
    
    public init(domain: StringConvetable, paths: [StringConvetable], items: [Item]) {
        self.domain = domain
        self.paths = paths
        self.items = items
    }
    
    static let kContentType = "Content-Type"
    
    static let seperator = "\r\n"
    
    public func toURLRequest() throws -> URLRequest {
        let components = [domain.toString()] + paths.map({$0.toString()})
        guard let url = URL(string: components.joined(separator: "/")) else {
            throw NetworkingError.invalidRequest
        }
        var req = URLRequest(url: url)
        let boundary = UUID().uuidString
        var data = Data()
        try data.append("--\(boundary)\(Self.seperator)".utf8Data())
        for item in self.items {
            try data.append("Content-Disposition:form-data; name=\"\(item.key)\"".utf8Data())
            switch item.value {
            case .string(let value):
                try data.append("\(Self.seperator)\(Self.seperator)\(value)".utf8Data())
            case .data(let d, let contentType, let filename):
                try data.append("; filename=\"\(filename)\"\(Self.seperator)".utf8Data())
                try data.append("\(Self.kContentType): \(contentType.rawValue)\(Self.seperator)\(Self.seperator)".utf8Data())
                data.append(d)
                try data.append(Self.seperator.utf8Data())
            }
        }
        try data.append("--\(boundary)--\(Self.seperator)".utf8Data())
        req.httpMethod = "POST"
        req.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: Self.kContentType)
        req.httpBody = data
        return req
    }
    
}

