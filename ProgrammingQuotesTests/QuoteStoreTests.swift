//
//  QuoteStoreTests.swift
//  ProgrammingQuotesTests
//
//  Created by Doan Le Thieu on 5/15/18.
//  Copyright © 2018 Doan Le Thieu. All rights reserved.
//

import XCTest
@testable import Blocks

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
        let mockURLSession = MockURLSession(data: nil, urlResponse: nil, error: nil)
        sut.session = mockURLSession
        
        sut.fetchRandomQuote { (_) in }
        
        XCTAssertEqual(mockURLSession.urlComponents?.host, "quotes.stormconsultancy.co.uk")
    }
    
    func testFetchRandomQuoteUsesCorrectPath() {
        let mockURLSession = MockURLSession(data: nil, urlResponse: nil, error: nil)
        sut.session = mockURLSession
        
        sut.fetchRandomQuote { (_) in }
        
        XCTAssertEqual(mockURLSession.urlComponents?.path, "/random.json")
    }
    
    func testFetchRandomQuoteSuccessfullyReturnQuote() {
        let jsonData = """
        {
        \"id\": 1,
        \"author\": \"Anon\",
        \"quote\": \"Lorem ipsum....\",
        \"permalink\": \"http://quotes.stormconsultancy.co.uk/quotes/1\"
        }
        """.data(using: .utf8)

        let mockURLSession = MockURLSession(data: jsonData, urlResponse: nil, error: nil)
        sut.session = mockURLSession
        
        let quoteExpectation = expectation(description: "Quote")
        var catchedQuote: Quote?
        
        sut.fetchRandomQuote { (result) in
            switch result {
            case let .success(quote):
                catchedQuote = quote
                quoteExpectation.fulfill()
            case .failure:
                XCTFail("Should be successful, not error")
                return
            }
        }
        
        waitForExpectations(timeout: 1.0) { (_) in
            XCTAssertNotNil(catchedQuote)
            XCTAssertEqual(catchedQuote!.text, "Lorem ipsum....")
            XCTAssertEqual(catchedQuote!.authorName, "Anon")
        }
    }
    
    func testFetchRandomQuoteFailedWithInvalidData() {
        let mockURLSession = MockURLSession(data: Data(), urlResponse: nil, error: nil)
        sut.session = mockURLSession
        
        let errorExpectation = expectation(description: "Invalid Data Error")
        var catchedError: Error?
        
        sut.fetchRandomQuote { (result) in
            switch result {
            case .success:
                XCTFail("Should be failed because of invalid data")
                return
            case let .failure(error):
                catchedError = error
                errorExpectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 1.0) { (_) in
            XCTAssertNotNil(catchedError)
        }
    }
    
    func testFetchRandomQuoteFailedWithNilData() {
        let mockURLSession = MockURLSession(data: nil, urlResponse: nil, error: nil)
        sut.session = mockURLSession
        
        let errorExpectation = expectation(description: "Nil Data Error")
        var catchedError: Error?
        
        sut.fetchRandomQuote { (result) in
            switch result {
            case .success:
                XCTFail("Should be failed because of nil data")
                return
            case let .failure(error):
                catchedError = error
                errorExpectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 1.0) { (_) in
            XCTAssertNotNil(catchedError)
        }
    }
    
    func testFetchRandomQuoteFailedWithError() {
        let jsonData = """
        {
        \"id\": 1,
        \"author\": \"Anon\",
        \"quote\": \"Lorem ipsum....\",
        \"permalink\": \"http://quotes.stormconsultancy.co.uk/quotes/1\"
        }
        """.data(using: .utf8)
        
        let error = NSError(domain: "Error", code: 1234, userInfo: nil)
        
        let mockURLSession = MockURLSession(data: jsonData, urlResponse: nil, error: error)
        sut.session = mockURLSession
        
        let errorExpectation = expectation(description: "Response with Error")
        var catchedError: Error?
        
        sut.fetchRandomQuote { (result) in
            switch result {
            case .success:
                XCTFail("Should be failed because of returned error")
                return
            case let .failure(error):
                catchedError = error
                errorExpectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 1.0) { (_) in
            XCTAssertNotNil(catchedError)
        }
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
        
        private let dataTask: MockTask
        
        init(data: Data?, urlResponse: URLResponse?, error: Error?) {
            dataTask = MockTask(data: data, urlResponse: urlResponse, error: error)
        }
        
        override func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
            catchedURL = url
            
            dataTask.completionHandler = completionHandler
            
            return dataTask
        }
    }
    
    class MockTask: URLSessionDataTask {
        
        private let data: Data?
        private let urlResponse: URLResponse?
        private let responseError: Error?
        
        // swiftlint:disable nesting
        typealias CompletionHandler = (Data?, URLResponse?, Error?) -> Void
        var completionHandler: CompletionHandler?
        
        init(data: Data?, urlResponse: URLResponse?, error: Error?) {
            self.data = data
            self.urlResponse = urlResponse
            self.responseError = error
        }
        
        override func resume() {
            DispatchQueue.main.async {
                self.completionHandler?(self.data, self.urlResponse, self.responseError)
            }
        }
    }
}
