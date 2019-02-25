//
//  DetailViewController.swift
//  inventoryapp
//
//  Created by Brett Romero on 12/27/16.
//  Copyright © 2016 test. All rights reserved.
//

import UIKit
import SafariServices

class DetailViewController: UIViewController {

    @IBOutlet var name: UILabel!
    @IBOutlet var units: UILabel!
    @IBOutlet var vendor: UILabel!
    @IBOutlet var vendorUrl: UILabel!
    @IBOutlet var vendorLogo: UIImageView!
    
    var inventoryItem:InventoryItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.name.text = inventoryItem?.name
        self.units.text = String(describing: (inventoryItem?.units)!)
        self.vendor.text = inventoryItem?.manufacturerName
        
       inventoryItem?.getImage(completion: { (image) in
            DispatchQueue.main.async() { // set up your view in main thread
                self.vendorLogo.image = image
            }
        })

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
