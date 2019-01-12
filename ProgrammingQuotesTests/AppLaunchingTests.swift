//
//  AppLaunchingTests.swift
//  ProgrammingQuotesTests
//
//  Created by Doan Le Thieu on 5/15/18.
//  Copyright © 2018 Doan Le Thieu. All rights reserved.
//

import XCTest
@testable import Blocks

class AppLaunchingTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testIsAppRootViewController() {
        guard let rootViewController = UIApplication.shared.keyWindow?.rootViewController else {
            XCTFail("Failed initialize app")
            return
        }
        
        XCTAssertTrue(rootViewController is QuoteViewController)
    }
}
