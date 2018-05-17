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
    
    lazy var nextQuoteButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.setTitle("Next Quote", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.setImage(UIImage(named: "nextButton"), for: .normal)
        button.tintColor = .darkGray
        
        // align image to the right edge (with magic numbers)
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 0)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 85, bottom: 0, right: 0)
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: -40, bottom: 0, right: 0)
        
        return button
    }()
    
    lazy var shareButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.setImage(UIImage(named: "shareButton"), for: .normal)
        button.tintColor = .darkGray
        
        return button
    }()
    
    // MARK: Data
    
    var quote: Quote?
    var quoteStore: QuoteStore!
    
    // MARK: Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
}

// MARK: -

private extension QuoteViewController {
    
    func setupView() {
        view.backgroundColor = .white
        
        // set up the labels
        
        let labelsContainerView = UIView()
        labelsContainerView.translatesAutoresizingMaskIntoConstraints = false
        
        let labelStack = UIStackView(arrangedSubviews: [textLabel, authorNameLabel])
        labelStack.translatesAutoresizingMaskIntoConstraints = false
        
        labelStack.axis = .vertical
        labelStack.alignment = .fill
        labelStack.distribution = .fill
        labelStack.spacing = 16
        
        labelsContainerView.addSubview(labelStack)
        view.addSubview(labelsContainerView)
        
        // constraint labelStack within labelContainerView
        NSLayoutConstraint.activate([
            labelStack.leadingAnchor.constraint(equalTo: labelsContainerView.leadingAnchor),
            labelStack.trailingAnchor.constraint(equalTo: labelsContainerView.trailingAnchor),
            labelStack.centerYAnchor.constraint(equalTo: labelsContainerView.centerYAnchor),
            labelStack.heightAnchor.constraint(lessThanOrEqualTo: labelsContainerView.heightAnchor, multiplier: 0.9)])
        
        let margins = view.layoutMarginsGuide
        let safeArea = view.safeAreaLayoutGuide
        
        // constraint labelsContainerView within root view
        NSLayoutConstraint.activate([
            labelsContainerView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            labelsContainerView.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
            labelsContainerView.trailingAnchor.constraint(equalTo: margins.trailingAnchor)])

        // setup buttons
        
        let buttonsContainerView = UIView()
        buttonsContainerView.translatesAutoresizingMaskIntoConstraints = false
        
        buttonsContainerView.addSubview(nextQuoteButton)
        buttonsContainerView.addSubview(shareButton)
        view.addSubview(buttonsContainerView)
        
        // constraint buttonsContainerView within root view
        NSLayoutConstraint.activate([
            buttonsContainerView.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
            buttonsContainerView.trailingAnchor.constraint(equalTo: margins.trailingAnchor),
            buttonsContainerView.heightAnchor.constraint(equalToConstant: 40),
            buttonsContainerView.topAnchor.constraint(equalTo: labelsContainerView.bottomAnchor),
            buttonsContainerView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor)])
        
        // constraint buttons within buttonsContainerView
        NSLayoutConstraint.activate([
            nextQuoteButton.trailingAnchor.constraint(equalTo: buttonsContainerView.trailingAnchor),
            nextQuoteButton.centerYAnchor.constraint(equalTo: buttonsContainerView.centerYAnchor),
            shareButton.leadingAnchor.constraint(equalTo: buttonsContainerView.leadingAnchor),
            shareButton.centerYAnchor.constraint(equalTo: buttonsContainerView.centerYAnchor)])
        
        // add target-action
        nextQuoteButton.addTarget(self, action: #selector(showNextQuote(_:)), for: .touchUpInside)
        shareButton.addTarget(self, action: #selector(displayActivityMenu(_:)), for: .touchUpInside)
    }
    
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
