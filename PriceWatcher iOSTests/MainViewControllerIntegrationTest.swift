//
//  MainViewControllerTest.swift
//  PriceWatcher-iOSTests
//
//  Created by Fahim Jatmiko on 20/03/22.
//

import XCTest
@testable import PriceWatcher_iOS

class MainViewControllerIntegrationTest: XCTestCase {
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
    
    func test_instantiateViewController_TableViewLoadsNoData() {
        let sut = makeSut()
        sut.loadViewIfNeeded()
        
        XCTAssertEqual(0, sut.tableView.numberOfRows(inSection: 0))
    }
    
    func test_FetchDataOnceAndInstantiateViewController_TableViewLoadsDataFromLocal() {
        fetchRemotellyAndSaveDataToLocal(with: getSampleJsonData(fileName: "currentprice"))
        
        let sut = makeSut()
        sut.loadViewIfNeeded()
        
        Thread.sleep(forTimeInterval: 0.7)
        
        XCTAssertEqual(sut.tableView.numberOfRows(inSection: 0), 1)
    }
    
    func test_FetchData6TimesAndInstantiateViewController_LoadsDataFromLocal() {
        fetchRemotellyAndSaveDataToLocal(with: getSampleJsonData(fileName: "currentprice"))
        fetchRemotellyAndSaveDataToLocal(with: getSampleJsonData(fileName: "currentprice2"))
        fetchRemotellyAndSaveDataToLocal(with: getSampleJsonData(fileName: "currentprice3"))
        fetchRemotellyAndSaveDataToLocal(with: getSampleJsonData(fileName: "currentprice4"))
        fetchRemotellyAndSaveDataToLocal(with: getSampleJsonData(fileName: "currentprice5"))
        fetchRemotellyAndSaveDataToLocal(with: getSampleJsonData(fileName: "currentprice6"))
        
        let sut = makeSut()
        sut.loadViewIfNeeded()
        
        Thread.sleep(forTimeInterval: 1)
        
        XCTAssertEqual(sut.tableView.numberOfRows(inSection: 0), 5)
        XCTAssertEqual(6,sut.lineChartView.lineData!.entryCount)
    }
    
    // MARK: Helpers
    
    private func makeSut(file: StaticString = #filePath, line: UInt = #line) -> MainViewController {
        let localPriceSeriesLoader = LocalPriceSeriesLoader()
        let localPriceDataRequestActivityCache = LocalPriceDataRequestActivityCache()
        let presenter = MainViewPresenter(priceSeriesLoader: localPriceSeriesLoader, cache: localPriceDataRequestActivityCache)
        let mainViewController = MainViewController(presenter: presenter)
        presenter.mainView = mainViewController
        trackForMemoryLeaks(mainViewController, file: file, line: line)
        return mainViewController
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
    
    private func getSampleJsonData(fileName:String) -> Data {
        let bundle = Bundle(for: type(of: self))
        let path = bundle.path(forResource: fileName, ofType: "json")!
        let data = try! Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
        return data
    }
    
    private func fetchRemotellyAndSaveDataToLocal(with remoteDataStub:Data) {
        let urlSessionHttpClient = UrlSessionHttpClient(session: URLSession.shared)
        let remotePriceLoader = RemotePriceLoader(httpClient: urlSessionHttpClient)
        let localPriceDataRequestActivityCache = LocalPriceDataRequestActivityCache()
        let mockLocationManager = MockLocationManager()
        let dataRequestActivityManager = DataRequestActivityManager(loader: remotePriceLoader, cache: localPriceDataRequestActivityCache, locationManager: mockLocationManager)
        
        let expectation = expectation(description: "wait async")
        URLProtocolStub.stub(data: remoteDataStub, response: anyHTTPURLResponse(), error: nil)
        Task.init {
            try! await dataRequestActivityManager.loadRemotelyAndCache()
            let cacheData = try! await dataRequestActivityManager.loadCache()
            XCTAssert(!cacheData.isEmpty)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 2)
    }
}
