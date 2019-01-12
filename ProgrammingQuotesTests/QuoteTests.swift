//
//  QuoteTests.swift
//  ProgrammingQuotesTests
//
//  Created by Doan Le Thieu on 5/15/18.
//  Copyright © 2018 Doan Le Thieu. All rights reserved.
//

import XCTest
@testable import Blocks

class QuoteTests: XCTestCase {
    
    var quote: Quote!
    
    override func setUp() {
        super.setUp()
        
        quote = Quote(text: "This is a quote", authorName: "John")
    }
    
    override func tearDown() {
        super.tearDown()
    }
 
    func testQuoteHasText() {
        XCTAssertEqual(quote.text, "This is a quote")
    }
    
    func testQuoteHasAuthorName() {
        XCTAssertEqual(quote.authorName, "John")
    }
}
