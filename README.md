# Networking

This networking libaray can make sending http request and decoding response very easy.

# Functions
- [x] Http Client
- [ ] UDP Client
- [ ] WebSocket Client

## Installation
### Swift Package Manager

Once you have your Swift package set up, you add this code to your Package.swift. 
```swift
dependencies: [
    .package(url: "https://github.com/LoniQin/Networking", .upToNextMajor(from: "1.0.0"))
]
```
 In Xcode, you can choose File->Swift Packages->Add Pakcage dependancies, and add https://github.com/LoniQin/Networking.
 
 ## How to use
 The two important protocol are `RequestConvertable`, `ResponseConvertable`. Namely objects and structs that confirms to `RequestConvertable` can convert to URLRequest type, and that confirms to `ResponseConvertable` can convert from URLResponse to that specific type. 
 ### `RequestConvertable` and `ResponseConvertable`
 `RequestConvertable` can convert an object to a `URL`, and `ResponseConvertable` can convert a response Data to types that confirms to it.
 ```swift
 
 public protocol RequestConvertable {
     func toURLRequest() throws -> URLRequest
 }
 public protocol ResponseConvertable {
     static func toResponse(with data: Data) throws -> Self
 }

 ```
 ### Types confirms to `RequestConvertable`
 * `String`
 * `URL`
 * `URLRequest`
 * `Form`
 * `HttpRequest`
 
 ### Types confirms to `ResponseConvertable`
 * `String`
 * `Data`
 * `URLRequest`
 * `JSONCodable`
 * `UIImage`
 
Request this README.md and convert to Data using a `String`, `URL`, `URLRequet` that all represents a link:
```swift
HttpClient.default.send("https://github.com/LoniQin/Crypto/blob/master/README.md") { (result: Result<Data, Error>) in
    switch result {
    case .failure(let error):
        print(error)
    case .success(let data):
        print(data)
    }
}

HttpClient.default.send(URL(string: "https://github.com/LoniQin/Crypto/blob/master/README.md")!) { (result: Result<Data, Error>) in
    switch result {
    case .failure(let error):
        print(error)
    case .success(let data):
        print(data)
    }
}
HttpClient.default.send(URLRequest(url: URL(string: "https://github.com/LoniQin/Crypto/blob/master/README.md")!)) { (result: Result<Data, Error>) in
    switch result {
    case .failure(let error):
        print(error)
    case .success(let data):
        print(data)
    }
}
```

Requst `String` using `HttpRequest`:
```swift
let request = HttpRequest(domain: "https://github.com", paths: ["LoniQin", "Crypto", "blob", "master", "README.md"], method: .get)
HttpClient.default.send(request) { (result: Result<String, Error>) in
    switch result {
    case .failure(let error):
        print(error)
    case .success(let data):
        print(data)
    }
}
```


Request `UIImage`
```swift
HttpClient.default.send("https://raw.githubusercontent.com/LoniQin/Networking/master/Tests/mock_data/cat.jpg") { (result: Result<UIImage, Error>) in
    do {
        _ = try result.get()
    } catch let error {
        print(error)
    }
}
```

You can define your own type that confirms to `JSONCodable`, to decode JSON data from web server.

```swift
struct User: JSONCodable {
    let name: String
}

HttpClient.default.send("https://raw.githubusercontent.com/LoniQin/Networking/master/Tests/data/mockUser.json") { (result: Result<User, Error>) in
    switch result {
    case .failure(let error):
        print(error)
    case .success(let data):
        print(data)
    }
}
```

