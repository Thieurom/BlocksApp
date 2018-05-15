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
    
    // MARK: Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(textLabel)
        view.addSubview(authorNameLabel)
        view.addSubview(nextQuoteButton)
    }
}
