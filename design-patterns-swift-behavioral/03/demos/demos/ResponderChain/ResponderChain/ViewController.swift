//
//  Design Pattern in Swift: Behavioral - https://app.pluralsight.com/library/courses/design-patterns-swift-behavioral
//
//  ViewController.swift
//  ResponderChain
//
//  Created by Nyisztor, Karoly on 8/14/17.
//  Copyright © 2017 Nyisztor, Karoly. All rights reserved.
//

import UIKit

extension UIView {
    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("UIView: \(#function) called")
        next?.touchesBegan(touches, with: event)
    }
}

extension UIWindow {
    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("UIWindow: \(#function) called")
        next?.touchesBegan(touches, with: event)
    }
}

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("ViewController: \(#function) called")
        next?.touchesBegan(touches, with: event)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

