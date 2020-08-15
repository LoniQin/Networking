import XCTest
@testable import Networking

final class NetworkingTests: XCTestCase {

    func testSendAndReceiveRequest1() {
        let expectation = self.expectation(description: "test request")
        let client = HttpClient()
        client.send("https://raw.githubusercontent.com/LoniQin/SwiftNetworking/master/README.md", success: { (data: Data) in
            print(data)
            expectation.fulfill()
        }) { (error) in
            print(error)
        }
        self.waitForExpectations(timeout: 30) { (error) in
            
        }
        
    }
    
    func testSendAndReceiveRequest2() {
        let expectation = self.expectation(description: "test request")
        let client = HttpClient()
        client.send("https://raw.githubusercontent.com/LoniQin/SwiftNetworking/master/README.md", success: { (item: String) in
            print(item)
            expectation.fulfill()
        }) { (error) in
            print(error)
        }
        self.waitForExpectations(timeout: 30) { (error) in
            
        }
        
    }

    static var allTests = [
        ("testRequest1", testSendAndReceiveRequest1),
        ("testRequest2", testSendAndReceiveRequest2),
    ]
}
