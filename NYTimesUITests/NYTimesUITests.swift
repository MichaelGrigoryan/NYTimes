//
//  NYTimesUITests.swift
//  NYTimesUITests
//
//  Created by Michael Grigoryan on 12/10/20.
//

import XCTest
@testable import NYTimes

class NYTimesUITests: XCTestCase {
    
    // MARK: - XCTest's Life Cycle
    
    func testExample() throws {
        let app = XCUIApplication()
        app.launch()
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
