import XCTest
@testable import Networking

final class NetworkingTests: XCTestCase {

    func testSendAndReceiveRequest1() {
        let expectation = self.expectation(description: "test request")
        let client = HttpClient()
        client.send("https://github.com/LoniQin/Crypto/blob/master/README.md") { (result: Result<Data,Error>) in
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
        let client = HttpClient()
        client.send("https://github.com/LoniQin/Crypto/blob/master/README.md") { (result: Result<String, Error>) in
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

    static var allTests = [
        ("testRequest1", testSendAndReceiveRequest1),
        ("testRequest2", testSendAndReceiveRequest2),
    ]
}
