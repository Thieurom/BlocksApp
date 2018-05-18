//
//  QuoteViewController.swift
//  ProgrammingQuotes
//
//  Created by Doan Le Thieu on 5/15/18.
//  Copyright © 2018 Doan Le Thieu. All rights reserved.
//

import UIKit

class QuoteViewController: UIViewController {
    
    // MARK: Constants
    
    private struct PropertyKeys {
        static let labelsOffset: CGFloat = 24.0
        static let buttonsContainerHeight: CGFloat = 40.0
    }
    
    // MARK: - Views
    
    lazy var textLabel: UILabel = {
        let label = UILabel()
        
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textColor = .black
        label.textAlignment = .left
        label.numberOfLines = 0
        
        return label
    }()
    
    lazy var authorNameLabel: UILabel = {
        let label = UILabel()
        
        label.textColor = .gray
        label.textAlignment = .right
        
        return label
    }()
    
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
    
    lazy var spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView()
        
        spinner.color = .gray
        spinner.translatesAutoresizingMaskIntoConstraints = false
        
        return spinner
    }()
    
    // MARK: Data
    
    var quote: Quote? {
        didSet {
            updateView()
        }
    }
    
    var quoteStore: QuoteStore!
    
    // MARK: Constraint references
    
    var labelsCenterYConstraint: NSLayoutConstraint!
    var nextQuoteButtonLeadingConstraint: NSLayoutConstraint!
    var nextQuoteButtonTrailingConstraint: NSLayoutConstraint!
    var shareButtonLeadingConstraint: NSLayoutConstraint!
    var shareButtonTrailingConstraint: NSLayoutConstraint!
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        showQuote()
    }
}

// MARK: -

private extension QuoteViewController {
    
    // swiftlint:disable function_body_length
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
        labelsContainerView.addSubview(spinner)
        view.addSubview(labelsContainerView)
        
        // constraint labelStack within labelContainerView
        NSLayoutConstraint.activate([
            labelStack.leadingAnchor.constraint(equalTo: labelsContainerView.leadingAnchor),
            labelStack.trailingAnchor.constraint(equalTo: labelsContainerView.trailingAnchor),
//            labelStack.centerYAnchor.constraint(equalTo: labelsContainerView.centerYAnchor),
            labelStack.heightAnchor.constraint(lessThanOrEqualTo: labelsContainerView.heightAnchor, multiplier: 0.9)])
        
        labelsCenterYConstraint = labelStack.centerYAnchor.constraint(equalTo: labelsContainerView.centerYAnchor)
        
        // starting position
        labelsCenterYConstraint.constant = -PropertyKeys.labelsOffset
        labelsCenterYConstraint.isActive = true
        
        // constraint spinner
        NSLayoutConstraint.activate([
            spinner.centerXAnchor.constraint(equalTo: labelsContainerView.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: labelsContainerView.centerYAnchor)])
        
        let margins = view.layoutMarginsGuide
        let safeArea = view.safeAreaLayoutGuide
        
        // constraint labelsContainerView within root view
        NSLayoutConstraint.activate([
            labelsContainerView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            labelsContainerView.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
            labelsContainerView.trailingAnchor.constraint(equalTo: margins.trailingAnchor)])
        
        // for the case the textLabel has to display a very long text
        textLabel.adjustsFontSizeToFitWidth = true
        textLabel.minimumScaleFactor = 0.75
        authorNameLabel.setContentCompressionResistancePriority(.defaultHigh + 1, for: .vertical)
        
        // initially hide labels
        textLabel.alpha = 0
        authorNameLabel.alpha = 0

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
            buttonsContainerView.heightAnchor.constraint(equalToConstant: PropertyKeys.buttonsContainerHeight),
            buttonsContainerView.topAnchor.constraint(equalTo: labelsContainerView.bottomAnchor),
            buttonsContainerView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor)])
        
        // constraint buttons within buttonsContainerView
        NSLayoutConstraint.activate([
            nextQuoteButton.centerYAnchor.constraint(equalTo: buttonsContainerView.centerYAnchor),
            shareButton.centerYAnchor.constraint(equalTo: buttonsContainerView.centerYAnchor)])
        
        nextQuoteButtonTrailingConstraint = nextQuoteButton.trailingAnchor.constraint(equalTo: buttonsContainerView.trailingAnchor)
        nextQuoteButtonLeadingConstraint = nextQuoteButton.leadingAnchor.constraint(equalTo: view.trailingAnchor)
        
        shareButtonLeadingConstraint = shareButton.leadingAnchor.constraint(equalTo: buttonsContainerView.leadingAnchor)
        shareButtonTrailingConstraint = shareButton.trailingAnchor.constraint(equalTo: view.leadingAnchor)
        
        // starting positions
        nextQuoteButtonLeadingConstraint.isActive = true
        shareButtonTrailingConstraint.isActive = true
        
        // add target-action
        nextQuoteButton.addTarget(self, action: #selector(showNextQuote(_:)), for: .touchUpInside)
        shareButton.addTarget(self, action: #selector(displayActivityMenu(_:)), for: .touchUpInside)
    }
    
    func updateView() {
        spinner.stopAnimating()
        
        if let quote = quote {
            textLabel.text = quote.text
            authorNameLabel.text = "— \(quote.authorName)"
        } else {
            textLabel.text = "This is not a quote! There's actually some error!"
            authorNameLabel.text = ""
        }
        
        // update layout upon label's content changed
        view.layoutIfNeeded()
        
        // move labels to center and show buttons
        labelsCenterYConstraint.constant = 0
        nextQuoteButtonLeadingConstraint.isActive = false
        nextQuoteButtonTrailingConstraint.isActive = true
        shareButtonTrailingConstraint.isActive = false
        shareButtonLeadingConstraint.isActive = true
        
        // animate
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
            self.textLabel.alpha = 1
            self.authorNameLabel.alpha = 1
            self.view.layoutIfNeeded()
        })
    }
    
    func showQuote() {
        spinner.startAnimating()

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
    
    @objc func showNextQuote(_ sender: UIButton) {
        // offset labels upward
        labelsCenterYConstraint.constant = -PropertyKeys.labelsOffset
        
        // hide buttons from screen
        nextQuoteButtonTrailingConstraint.isActive = false
        nextQuoteButtonLeadingConstraint.isActive = true
        shareButtonLeadingConstraint.isActive = false
        shareButtonTrailingConstraint.isActive = true
        
        // animate
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
            self.textLabel.alpha = 0
            self.authorNameLabel.alpha = 0
            self.view.layoutIfNeeded()
        }, completion: { (_) in
            self.showQuote()
        })
    }
    
    @objc func displayActivityMenu(_ sender: UIButton) {
        guard let quote = quote else {
            return
        }
        
        let sharingContent = "\(quote.text) — \(quote.authorName)"
        let activityViewController = UIActivityViewController(activityItems: [sharingContent], applicationActivities: nil)
        
        present(activityViewController, animated: true, completion: nil)
    }
}
