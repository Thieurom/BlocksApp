//
//  Quote.swift
//  ProgrammingQuotes
//
//  Created by Doan Le Thieu on 5/15/18.
//  Copyright © 2018 Doan Le Thieu. All rights reserved.
//

import Foundation

struct Quote {
    var text: String
    var authorName: String
}

extension Quote: Decodable {
    
    private enum CodingKeys: String, CodingKey {
        case text = "quote"
        case authorName = "author"
    }
    
    init(from decoder: Decoder) throws {
        let valueContainer = try decoder.container(keyedBy: CodingKeys.self)
        
        self.text = try valueContainer.decode(String.self, forKey: CodingKeys.text)
        self.authorName = try valueContainer.decode(String.self, forKey: CodingKeys.authorName)
    }
}
