//
//  XCTest+MemoryLeakTracking.swift
//  PriceWatcher-iOSTests
//
//  Created by Fahim Jatmiko on 19/03/22.
//
import XCTest

extension XCTestCase {
    func trackForMemoryLeaks(_ instance: AnyObject, file: StaticString = #filePath, line: UInt = #line) {
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance, "Instance should have been deallocated. Potential memory leak.", file: file, line: line)
        }
    }
}
