//
//  QuoteStore.swift
//  ProgrammingQuotes
//
//  Created by Doan Le Thieu on 5/15/18.
//  Copyright © 2018 Doan Le Thieu. All rights reserved.
//

import Foundation

enum QuoteResult {
    case success(Quote)
    case failure(Error)
}

class QuoteStore {
    
    lazy var session: URLSession = URLSession.shared
    
    func fetchRandomQuote(completion: @escaping (QuoteResult) -> Void) {
        let url: URL = ProgrammingQuotesAPI.randomQuoteURL
        
        session.dataTask(with: url) { (data, _, error) in
            guard error == nil else {
                completion(.failure(error!))
                return
            }
            
            guard let data = data else {
                let error = ProgrammingQuotesError.emptyData
                completion(.failure(error))
                return
            }
            
            guard let quote = try? JSONDecoder().decode(Quote.self, from: data) else {
                let error = ProgrammingQuotesError.invalidJSONData
                completion(.failure(error))
                return
            }
            
            completion(.success(quote))
        }
        .resume()
    }
}
