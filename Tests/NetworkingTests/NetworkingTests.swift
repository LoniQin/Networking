import XCTest
@testable import Networking

final class NetworkingTests: XCTestCase {

    func testSendAndReceiveRequest() {
        let expectation = self.expectation(description: "test request")
        let client = HttpClient()
        client.send("https://www.baidu.com", success: { (data: Data) in
            print(data)
            expectation.fulfill()
        }) { (error) in
            print(error)
        }
        self.waitForExpectations(timeout: 30) { (error) in
            
        }
    }

    static var allTests = [
        ("testRequest", testSendAndReceiveRequest),
    ]
}
