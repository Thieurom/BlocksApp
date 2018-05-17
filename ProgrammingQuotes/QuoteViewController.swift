//
//  QuoteViewController.swift
//  ProgrammingQuotes
//
//  Created by Doan Le Thieu on 5/15/18.
//  Copyright © 2018 Doan Le Thieu. All rights reserved.
//

import UIKit

class QuoteViewController: UIViewController {
    
    // MARK: Views
    
    lazy var textLabel: UILabel = UILabel()
    lazy var authorNameLabel: UILabel = UILabel()
    lazy var nextQuoteButton: UIButton = UIButton()
    lazy var shareButton: UIButton = UIButton()
    
    // MARK: Data
    
    var quote: Quote?
    var quoteStore: QuoteStore!
    
    // MARK: Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(textLabel)
        view.addSubview(authorNameLabel)
        view.addSubview(nextQuoteButton)
        view.addSubview(shareButton)
        
        nextQuoteButton.addTarget(self, action: #selector(showNextQuote(_:)), for: .touchUpInside)
        
        shareButton.addTarget(self, action: #selector(displayActivityMenu(_:)), for: .touchUpInside)
    }
}

// MARK: -

private extension QuoteViewController {
    
    @objc func showNextQuote(_ sender: UIButton) {
        quoteStore.fetchRandomQuote { (quoteResult) in
            DispatchQueue.main.async {
                switch quoteResult {
                case let .success(quote):
                    self.quote = quote
                case let .failure(error):
                    self.quote = nil
                    print("Error: \(error)")
                }
            }
        }
    }
    
    @objc func displayActivityMenu(_ sender: UIButton) {
        let activityViewController = UIActivityViewController(activityItems: ["Sharing content"], applicationActivities: nil)
        
        present(activityViewController, animated: true, completion: nil)
    }
}
