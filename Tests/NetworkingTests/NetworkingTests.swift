import XCTest
@testable import Networking
#if canImport(UIKit)
import UIKit
#endif

func / (lhs: String, rhs: String) -> String {
    lhs  + "/" + rhs
}

final class NetworkingTests: XCTestCase {
    
    func testPath() -> String {
        var components = #file.components(separatedBy: "/")
        components.removeLast(2)
        return components.joined(separator: "/")
    }

    func dataPath() -> String {
        testPath() / "data"
    }
    
    func expectation(title: String = #function, timeout: TimeInterval = 30, block: (XCTestExpectation) -> Void) {
        let expectation = self.expectation(description: title)
        block(expectation)
        self.waitForExpectations(timeout: 30) { (error) in
            if error != nil {
                XCTFail(error.debugDescription)
            }
        }
    }

    struct User: JSONCodable {
        let id: Int
        let name: String
    }
    
    func testSendAndReceiveRequest1() {
        let expectation = self.expectation(description: "test request")
        HttpClient.default.send("https://github.com/LoniQin/Crypto/blob/master/README.md") { (result: Result<Data,Error>) in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let data):
                print(data)
                expectation.fulfill()
            }
        }
        self.waitForExpectations(timeout: 30) { (error) in
            
        }
        
    }
    
    func testSendAndReceiveRequest2() {
        let expectation = self.expectation(description: "test request")
        HttpClient.default.send("https://github.com/LoniQin/Crypto/blob/master/README.md") { (result: Result<String, Error>) in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let data):
                print(data)
                expectation.fulfill()
            }
        }
        self.waitForExpectations(timeout: 30) { (error) in
            
        }
        
    }
    
    func testHttpClientWithHttpRequest() {
        
        let request = HttpRequest(domain: "https://github.com", paths: ["LoniQin", "Crypto", "blob", "master", "README.md"], method: .get)
        XCTAssertEqual(try request.toURLRequest().url, try "https://github.com/LoniQin/Crypto/blob/master/README.md".toURLRequest().url)
        let expectation = self.expectation(description: "test request")
        HttpClient.default.send(request) { (result: Result<String, Error>) in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let data):
                print(data)
                expectation.fulfill()
            }
        }
        self.waitForExpectations(timeout: 30) { (error) in
            
        }
        
    }
    
    func testHttpClientWithURLAndURLRequest() {
        let expectation = self.expectation(description: "test request")
        HttpClient.default.send(URLRequest(url: URL(string: "https://github.com/LoniQin/Crypto/blob/master/README.md")!)) { (result: Result<String, Error>) in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let data):
                print(data)
                expectation.fulfill()
            }
        }
        self.waitForExpectations(timeout: 30) { (error) in
            
        }
        
    }
    
    func testHttpClientWithURL() {
        let expectation = self.expectation(description: "test request")
        HttpClient.default.send(URL(string: "https://github.com/LoniQin/Crypto/blob/master/README.md")!) { (result: Result<String, Error>) in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let data):
                print(data)
                expectation.fulfill()
            }
        }
        self.waitForExpectations(timeout: 30) { (error) in
            
        }
        
    }

    func testGetMockUser() {
        self.expectation { (expectation) in
            let filePath = dataPath() / "mockUser.json"
            HttpClient.default.send(URL(fileURLWithPath: filePath)) { (result: Result<User, Error>) in
                do {
                    let result = try result.get()
                    XCTAssert(result.id == 1)
                    XCTAssert(result.name == "Jack")
                    let data = try result.toData()
                    XCTAssert(data.count > 0)
                    expectation.fulfill()
                } catch let error {
                    XCTFail(error.localizedDescription)
                }
            }
        }
    }
    
    func testDataConvertable() {
        let data = Data()
        XCTAssertEqual(try data.toData(), data)
    }
    
    func testHttpRequest() {
        var request = HttpRequest(
            domain: "https://www.example.com",
            paths: ["user", "login"],
            method: .get,
            query: ["phone": "123456", "password": "123456"],
            header: ["Content-Type": "application/json"]
        )
        do {
            let urlRequest = try request.toURLRequest()
            XCTAssertEqual(urlRequest.allHTTPHeaderFields, ["Content-Type": "application/json"])
            XCTAssertEqual(urlRequest.url?.absoluteString, "https://www.example.com/user/login?password=123456&phone=123456")
            XCTAssertEqual(urlRequest.httpMethod, "GET")
        } catch let error {
            XCTFail(error.localizedDescription)
        }
        request = HttpRequest(
            domain: "https://www.example.com",
            paths: ["user", "signup"],
            method: .post,
            body: ["phone": "123456", "password": "123456"],
            header: ["Content-Type": "application/json"]
        )
        do {
            let urlRequest = try request.toURLRequest()
            XCTAssertEqual(urlRequest.allHTTPHeaderFields, ["Content-Type": "application/json"])
            XCTAssertEqual(urlRequest.url?.absoluteString, "https://www.example.com/user/signup")
            XCTAssertEqual(urlRequest.httpMethod, "POST")
            XCTAssertEqual(urlRequest.httpBody, try JSONSerialization.data(withJSONObject: ["phone": "123456", "password": "123456"], options: .prettyPrinted))
        } catch let error {
            XCTFail(error.localizedDescription)
        }
    }
    
    func testForm() {
        let form = Form(
            domain: "https://www.example.com",
            paths: ["user", "signup"],
            items: [
                .init(key: "phone", value: .string("123456")),
                .init(key: "password", value: .string("123456")),
                .init(key: "text", value: .data(data: Data(), contentType: .text_plain, fileName: "aaa.txt"))
        ])
        do {
            let request = try form.toURLRequest()
            XCTAssertEqual(request.url?.absoluteString, "https://www.example.com/user/signup")
            let contentType = request.value(forHTTPHeaderField: "Content-Type")
            XCTAssertEqual(contentType?.hasPrefix("multipart/form-data;"), true)
        } catch let error {
            XCTFail(error.localizedDescription)
        }
    }
    
    #if canImport(UIKit)
    
    func testDownloadImage() {
        self.expectation { expectation in
            let imagePath = dataPath() / "cat.jpg"
            print(imagePath)
            HttpClient.default.send(URL(fileURLWithPath: imagePath)) { (result: Result<UIImage, Error>) in
                do {
                    _ = try result.get()
                    expectation.fulfill()
                } catch let error {
                    XCTFail(error.localizedDescription)
                }
            }
        }
    }
    
    #endif

    static var allTests = [
        ("testRequest1", testSendAndReceiveRequest1),
        ("testRequest2", testSendAndReceiveRequest2),
        ("testHttpClientWithHttpRequest", testHttpClientWithHttpRequest),
        ("testHttpClientWithURLAndURLRequest", testHttpClientWithURLAndURLRequest),
        ("testHttpClientWithURL", testHttpClientWithURL),
        ("testDataConvertable", testDataConvertable),
        ("testHttpRequest", testHttpRequest),
        ("testForm", testForm),
        ("testGetMockUser", testGetMockUser),
    ]
}
