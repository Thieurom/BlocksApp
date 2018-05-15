//
//  QuoteViewControllerTests.swift
//  ProgrammingQuotesTests
//
//  Created by Doan Le Thieu on 5/15/18.
//  Copyright © 2018 Doan Le Thieu. All rights reserved.
//

import XCTest
@testable import ProgrammingQuotes

class QuoteViewControllerTests: XCTestCase {
    
    var sut: QuoteViewController!
    
    override func setUp() {
        super.setUp()
        
        sut = QuoteViewController()
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
    
    func testHasTextLabel() {
        UIApplication.shared.keyWindow?.rootViewController = sut
        
        sut.loadViewIfNeeded()
        
        XCTAssertNotNil(sut.textLabel)
        XCTAssertTrue(sut.textLabel.isDescendant(of: sut.view))
    }
}
