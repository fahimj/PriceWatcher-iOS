//
//  LocalLoaderTest.swift
//  PriceWatcher-iOSTests
//
//  Created by Fahim Jatmiko on 19/03/22.
//

import XCTest
@testable import PriceWatcher_iOS

class LocalLoaderTest: XCTestCase {
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
    }
    
    func test_load_returnsEmptyObject() async {
        let sut = LocalPriceLoader()
        let result = try! await sut.load()
        XCTAssert(result.count == 0)
    }
    
    func test_save_load_returnSameObject() async {
        let anyUserActivity = anyUserActivity()
        let sut = LocalPriceLoader()
        try! await sut.save(price: anyUserActivity.prices, longitude: anyUserActivity.location.longitude, latitude: anyUserActivity.location.latitude)
        let savedItems = try! await sut.load()
        
        XCTAssertEqual(savedItems, anyUserActivity.prices)
    }
    
    func test_save_twiceReturn2Objects() async {
        let anyUserActivity = anyUserActivity()
        let sut = LocalPriceLoader()
        try! await sut.save(price: anyUserActivity.prices, longitude: anyUserActivity.location.longitude, latitude: anyUserActivity.location.latitude)
        try! await sut.save(price: anyUserActivity.prices, longitude: anyUserActivity.location.longitude, latitude: anyUserActivity.location.latitude)
        let savedItems = try! await sut.load()
        
        var doubleData = anyUserActivity.prices
        doubleData.append(contentsOf: anyUserActivity.prices)
        
        XCTAssertEqual(savedItems, doubleData)
    }
    
    func test_delete_returnsNoError() async {
        let sut = LocalPriceLoader()
        sut.delete()
    }
    
    func test_save_delete_returnsNoData() async throws {
        let sut = LocalPriceLoader()
        let anyUserActivity = anyUserActivity()
        try await sut.save(price: anyUserActivity.prices, longitude: anyUserActivity.location.longitude, latitude: anyUserActivity.location.latitude)
        sut.delete()
        let prices = try await sut.load()
        XCTAssert(prices == [])
    }
    
    // MARK: Helpers
    private func anyPrice() -> Price {
        let price = Price(pairName: "BTCUSD", price: 55000, date: Date())
        return price
    }
    
    private func anyLocation() -> Location {
        let location = Location(latitude: 1.0, longitude: 1.5)
        return location
    }
    
    private func anyUserActivity() -> PriceDataRequestActivity {
        let price1 = anyPrice()
        let price2 = anyPrice()
        let price3 = anyPrice()
        let location = anyLocation()
        
        let userActivity = PriceDataRequestActivity(prices: [price1, price2, price3], location: location, date: Date())
        return userActivity
    }
}

extension Price : Equatable {
    public static func == (lhs: Price, rhs: Price) -> Bool {
        return lhs.pairName == rhs.pairName &&
        lhs.date == rhs.date &&
        lhs.price == rhs.price
    }
}
