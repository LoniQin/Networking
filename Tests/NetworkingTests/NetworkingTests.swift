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
                    expectation.fulfill()
                } catch let error {
                    XCTFail(error.localizedDescription)
                }
            }
        }
    }
    
    #if canImport(UIKit)
    
    func testDownloadImage() {
        self.expectation { expectation in
            let imagePath = dataPath() / "cat.jpg"
            print(imagePath)
            HttpClient.default.send(URL(fileURLWithPath: imagePath)) { (result: Result<UIImage, Error>) in
                do {
                    try result.get()
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
        ("testGetMockUser", testGetMockUser)
    ]
}
