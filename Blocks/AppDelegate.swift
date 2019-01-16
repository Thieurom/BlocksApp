//
//  AppDelegate.swift
//  Blocks
//
//  Created by Doan Le Thieu on 5/15/18.
//  Copyright © 2018 Doan Le Thieu. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = window ?? UIWindow()
        
        let quoteViewController = QuoteViewController()
        let quoteStore = QuoteStore()
        quoteViewController.quoteStore = quoteStore
        
        window!.rootViewController = quoteViewController
        window?.makeKeyAndVisible()

        return true
    }
}
