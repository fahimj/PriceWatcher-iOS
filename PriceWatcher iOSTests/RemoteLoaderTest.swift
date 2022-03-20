//
//  RemoteLoaderTest.swift
//  PriceWatcher-iOSTests
//
//  Created by Fahim Jatmiko on 19/03/22.
//

import XCTest
@testable import PriceWatcher_iOS

class RemoteLoaderTest: XCTestCase {
    override func tearDown() {
        super.tearDown()
        
        URLProtocolStub.removeStub()
    }
    
    func test_load_return3Items() {
        let expectation = expectation(description: "wait async")
        let jsonData = getSampleJsonData()
        let sut = makeSUT()
        URLProtocolStub.stub(data: jsonData, response: anyHTTPURLResponse(), error: nil)
        Task.init {
            do {
                let items = try await sut.load()
                XCTAssert(items.count == 3)
            } catch {
                XCTFail("should not fail")
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1)
    }
    
    // MARK: - Helpers
    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> RemotePriceLoader {
        let httpClient = makeHttpClient()
        let remotePriceLoader = RemotePriceLoader(httpClient: httpClient)
        trackForMemoryLeaks(remotePriceLoader, file: file, line: line)
        return remotePriceLoader
    }
    
    private func makeHttpClient(file: StaticString = #filePath, line: UInt = #line) -> HttpClient {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [URLProtocolStub.self]
        let session = URLSession(configuration: configuration)
        
        let sut = UrlSessionHttpClient(session: session)
        trackForMemoryLeaks(sut, file: file, line: line)
        return sut
    }
    
    private func getSampleJsonData() -> Data {
        let bundle = Bundle(for: type(of: self))
        let path = bundle.path(forResource: "currentprice", ofType: "json")!
        let data = try! Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
        return data
    }
}
