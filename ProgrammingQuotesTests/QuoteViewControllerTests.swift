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
        
        sut.loadViewIfNeeded()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testHasTextLabel() {
        XCTAssertNotNil(sut.textLabel)
        XCTAssertTrue(sut.textLabel.isDescendant(of: sut.view))
    }
    
    func testHasAuthorNameLabel() {
        XCTAssertNotNil(sut.authorNameLabel)
        XCTAssertTrue(sut.authorNameLabel.isDescendant(of: sut.view))
    }
    
    func testHasNextQuoteButton() {
        XCTAssertNotNil(sut.nextQuoteButton)
        XCTAssertTrue(sut.nextQuoteButton.isDescendant(of: sut.view))
    }
    
    func testNextQuoteButtonHasCorrectAction() {
        let button = sut.nextQuoteButton
        
        guard let actions = button.actions(forTarget: sut, forControlEvent: .touchUpInside) else {
            XCTFail("The button has no actions")
            return
        }
        
        XCTAssertTrue(actions.contains("showNextQuote:"))
    }
    
    func testHasQuoteInitiallyEqualNil() {
        XCTAssertNil(sut.quote)
    }
    
    func testNextQuoteButtonActionDidFetchRandomQuote() {
        let mockQuoteStore = MockQuoteStore()
        sut.quoteStore = mockQuoteStore
        
        let quote = Quote(text: "This is a quote", authorName: "John")
        let quoteResult = QuoteResult.success(quote)
        mockQuoteStore.quoteResult = quoteResult
        
        sut.nextQuoteButton.sendActions(for: .touchUpInside)
        
        XCTAssertTrue(mockQuoteStore.wasFetchRandomQuoteGotCalled)
    }
    
    func testSetQuoteAfterFetchRandomQuote() {
        let mockQuoteStore = MockQuoteStore()
        sut.quoteStore = mockQuoteStore
        
        let quote = Quote(text: "This is a quote", authorName: "John")
        let quoteResult = QuoteResult.success(quote)
        mockQuoteStore.quoteResult = quoteResult
        
        sut.nextQuoteButton.sendActions(for: .touchUpInside)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(100)) {
            XCTAssertNotNil(self.sut.quote)
            XCTAssertEqual(self.sut.quote?.text, "This is a quote")
            XCTAssertEqual(self.sut.quote?.authorName, "John")
        }
    }
    
    func testHasShareButton() {
        XCTAssertNotNil(sut.shareButton)
        XCTAssertTrue(sut.shareButton.isDescendant(of: sut.view))
    }
}

extension QuoteViewControllerTests {
    
    class MockQuoteStore: QuoteStore {
        
        var wasFetchRandomQuoteGotCalled = false
        var quoteResult: QuoteResult?
        
        override func fetchRandomQuote(completion: @escaping (QuoteResult) -> Void) {
            wasFetchRandomQuoteGotCalled = true
            completion(quoteResult!)
        }
    }
}
