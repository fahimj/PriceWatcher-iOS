//
//  DataRequestActivityTest.swift
//  PriceWatcher-iOSTests
//
//  Created by Fahim Jatmiko on 19/03/22.
//

import XCTest
@testable import PriceWatcher_iOS

class DataRequestActivityTest: XCTestCase {
    override func setUp() {
        super.setUp()
        let userDefaults = UserDefaults.standard
        userDefaults.set(nil, forKey: "SavedItem")
        userDefaults.synchronize()
    }
    
    override func tearDown() {
        super.tearDown()
        
        let userDefaults = UserDefaults.standard
        userDefaults.set(nil, forKey: "SavedItem")
        userDefaults.synchronize()
        
        URLProtocolStub.removeStub()
    }
    
    func test_readDataResponseAndSaveToLocal() async throws {
        let sut = makeSut()
        let jsonData = getSampleJsonData()
        URLProtocolStub.stub(data: jsonData, response: anyHTTPURLResponse(), error: nil)
        
        try await sut.loadAndCache()
        
        let prices = try await sut.load()
        XCTAssert(prices.count == 3)
    }
    
    // MARK: Helpers
    
    func makeSut() -> DataRequestActivityManager {
        
        let cache = LocalPriceLoader()
        let httpClient = makeHttpClient()
        let loader = RemotePriceLoader(httpClient: httpClient)
        let sut = DataRequestActivityManager(loader: loader, cache: cache, locationManager: MockLocationManager())
        trackForMemoryLeaks(sut)
        return sut
    }
    
    private func makeRemotePriceLoader(file: StaticString = #filePath, line: UInt = #line) -> RemotePriceLoader {
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
    
    private func anyHTTPURLResponse() -> HTTPURLResponse {
        return HTTPURLResponse(url: anyURL(), statusCode: 200, httpVersion: nil, headerFields: nil)!
    }
    
    func anyURL() -> URL {
        return URL(string: "http://any-url.com")!
    }
}
