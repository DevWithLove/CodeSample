//
//  Design Pattern in Swift: Behavioral - https://app.pluralsight.com/library/courses/design-patterns-swift-behavioral
//
//  AppDelegate.swift
//  ResponderChain
//
//  Created by Nyisztor, Karoly on 8/14/17.
//  Copyright © 2017 Nyisztor, Karoly. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("AppDelegate: \(#function) called")
    }
}

