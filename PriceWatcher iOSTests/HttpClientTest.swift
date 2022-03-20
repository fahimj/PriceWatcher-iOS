//
//  HttpClientTest.swift
//  PriceWatcher-iOSTests
//
//  Created by Fahim Jatmiko on 19/03/22.
//

import XCTest
@testable import PriceWatcher_iOS

class HttpClientTest: XCTestCase {
    override func tearDown() {
        super.tearDown()
        
        URLProtocolStub.removeStub()
    }
    
    func test_load_returnsAnyData() {
        let expectation = expectation(description: "wait async")
        let sut = makeSUT()
        URLProtocolStub.stub(data: anyData(), response: anyHTTPURLResponse(), error: nil)
        Task.init {
            do {
                let data = try await sut.load(urlString: anyURL().absoluteString)
                XCTAssert(data == anyData())
            } catch {
                XCTFail("should not fail")
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1)
    }
    // MARK: - Helpers
    
    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> HttpClient {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [URLProtocolStub.self]
        let session = URLSession(configuration: configuration)
        
        let sut = UrlSessionHttpClient(session: session)
        trackForMemoryLeaks(sut, file: file, line: line)
        return sut
    }
    
    private func anyHTTPURLResponse() -> HTTPURLResponse {
        return HTTPURLResponse(url: anyURL(), statusCode: 200, httpVersion: nil, headerFields: nil)!
    }
    
    private func nonHTTPURLResponse() -> URLResponse {
        return URLResponse(url: anyURL(), mimeType: nil, expectedContentLength: 0, textEncodingName: nil)
    }

}
