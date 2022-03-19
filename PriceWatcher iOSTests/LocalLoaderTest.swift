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
        let sut = LocalPriceDataRequestActivityLoader()
        let result = try! await sut.loadCache()
        XCTAssert(result.count == 0)
    }
    
    func test_save_load_returnSameObject() async {
        let anyUserActivity = anyUserActivity()
        let sut = LocalPriceDataRequestActivityLoader()
        try! await sut.save(price: anyUserActivity.prices, longitude: anyUserActivity.location.longitude, latitude: anyUserActivity.location.latitude)
        let savedItems = try! await sut.loadCache()
        
        XCTAssertEqual(savedItems.first!.prices, anyUserActivity.prices)
    }
    
    func test_save_twiceReturn2Objects() async {
        let anyUserActivity = anyUserActivity()
        let sut = LocalPriceDataRequestActivityLoader()
        try! await sut.save(price: anyUserActivity.prices, longitude: anyUserActivity.location.longitude, latitude: anyUserActivity.location.latitude)
        try! await sut.save(price: anyUserActivity.prices, longitude: anyUserActivity.location.longitude, latitude: anyUserActivity.location.latitude)
        let savedItems = try! await sut.loadCache()
        
        var doubleData = anyUserActivity.prices
        doubleData.append(contentsOf: anyUserActivity.prices)
        
        XCTAssertEqual(savedItems.flatMap{$0.prices}, doubleData)
    }
    
    func test_delete_returnsNoError() async {
        let sut = LocalPriceDataRequestActivityLoader()
        sut.delete()
    }
    
    func test_save_delete_returnsNoData() async throws {
        let sut = LocalPriceDataRequestActivityLoader()
        let anyUserActivity = anyUserActivity()
        try await sut.save(price: anyUserActivity.prices, longitude: anyUserActivity.location.longitude, latitude: anyUserActivity.location.latitude)
        sut.delete()
        let prices = try await sut.loadCache()
        XCTAssert(prices.isEmpty)
    }
    
    // MARK: Helpers
    private func anyPrice() -> Price {
        let price = Price(pairName: "BTCUSD", value: 55000, date: Date())
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
        lhs.value == rhs.value
    }
}
