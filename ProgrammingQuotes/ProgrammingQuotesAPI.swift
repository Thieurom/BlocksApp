//
//  ProgrammingQuotesAPI.swift
//  ProgrammingQuotes
//
//  Created by Doan Le Thieu on 5/15/18.
//  Copyright © 2018 Doan Le Thieu. All rights reserved.
//

import Foundation

enum ProgrammingQuotesError: Error {
    case invalidJSONData
}

struct ProgrammingQuotesAPI {
    
    private static let baseURLString = "http://quotes.stormconsultancy.co.uk"
    
    private enum ResourcePath {
        case randomQuote
        
        var description: String {
            switch self {
            case .randomQuote:
                return "/random.json"
            }
        }
    }
    
    static var randomQuoteURL: URL {
        let urlString = baseURLString + ResourcePath.randomQuote.description
        
        return URL(string: urlString)!
    }
}
