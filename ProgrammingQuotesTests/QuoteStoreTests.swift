//
//  QuoteStoreTests.swift
//  ProgrammingQuotesTests
//
//  Created by Doan Le Thieu on 5/15/18.
//  Copyright © 2018 Doan Le Thieu. All rights reserved.
//

import XCTest
@testable import ProgrammingQuotes

class QuoteStoreTests: XCTestCase {
    
    var sut: QuoteStore!
    
    override func setUp() {
        super.setUp()
        
        sut = QuoteStore()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testFetchRandomQuoteUsesCorrectHost() {
        let mockURLSession = MockURLSession()
        sut.session = mockURLSession
        
        sut.fetchRandomQuote()
        
        XCTAssertEqual(mockURLSession.urlComponents?.host, "quotes.stormconsultancy.co.uk")
    }
    
    func testFetchRandomQuoteUsesCorrectPath() {
        let mockURLSession = MockURLSession()
        sut.session = mockURLSession
        
        sut.fetchRandomQuote()
        
        XCTAssertEqual(mockURLSession.urlComponents?.path, "/random.json")
    }
}

extension QuoteStoreTests {
    
    class MockURLSession: URLSession {
        
        var catchedURL: URL?
        var urlComponents: URLComponents? {
            guard let url = catchedURL else {
                XCTFail("Should catch url")
                return nil
            }
            
            return URLComponents(url: url, resolvingAgainstBaseURL: true)
        }
        
        override func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
            catchedURL = url
            return URLSession.shared.dataTask(with: url, completionHandler: completionHandler)
        }
    }
}
