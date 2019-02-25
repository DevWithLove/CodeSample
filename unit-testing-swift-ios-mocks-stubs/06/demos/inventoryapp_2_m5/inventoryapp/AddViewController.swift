//
//  AddViewController.swift
//  inventoryapp
//
//  Created by Brett Romero on 12/27/16.
//  Copyright © 2016 test. All rights reserved.
//

import UIKit

class AddViewController: UIViewController {

    @IBOutlet var model: UITextField!
    @IBOutlet var units: UITextField!
    @IBOutlet var make: UITextField! //manufacturer
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func addButton_click(_ sender: AnyObject) {
        let i = InventoryItem(name: model.text!, units: Int32(units.text!)!, manufacturerName: make.text!)
        InventoryManager.add(item: i)
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
