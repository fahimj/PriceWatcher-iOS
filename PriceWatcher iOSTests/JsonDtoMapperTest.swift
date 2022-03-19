//
//  JsonDtoMapperTest.swift
//
//  Created by Fahim Jatmiko on 17/03/22.
//

import XCTest
@testable import PriceWatcher_iOS

class PriceWatcher_iOSTests: XCTestCase {
    typealias sut = CoinbaseJsonDtoMapper
    
    func test_mapToPrice_throwsErrorOnEmptyData() {
        do {
            let _ = try sut.mapToPrice(jsonData: Data())
        } catch {
            return
        }
        
        XCTFail()
    }
    
    func test_mapToPrice_throwsErrorOnInvalidData() {
        do {
            let _ = try sut.mapToPrice(jsonData: "any data".data(using: .ascii)!)
        } catch is DecodingError {
            return
        } catch {
            print(error.localizedDescription)
            XCTFail("Should catch decoding json error")
        }
        
        XCTFail("Should catch decoding json error")
    }
    
    func test_mapToPrice_returns3Items() {
        let data = getSampleJsonData()
        do {
            let result = try sut.mapToPrice(jsonData: data)
            XCTAssertTrue(result.count == 3)
        } catch {
            XCTFail("Should catch no error, but found error: \(error.localizedDescription)")
        }
    }
    
    // MARK: Helpers
    
    private func getSampleJsonData() -> Data {
        let bundle = Bundle(for: type(of: self))
        let path = bundle.path(forResource: "currentprice", ofType: "json")!
        let data = try! Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
        return data
    }
}
