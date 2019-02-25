//
//  ViewController.swift
//  inventoryapp
//
//  Created by Brett Romero on 12/27/16.
//  Copyright © 2016 test. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var tableViewMain: UITableView!
    var inventoryItem:InventoryItem = InventoryItem()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //tableViewMain.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableViewMain.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: tableview functions
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return InventoryManager.getCount()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath as IndexPath) as! TableViewCell
        let i = InventoryManager.getItem(index: indexPath.row)
        //cell.textLabel?.text = i.name
        cell.name.font = UIFont.systemFont(ofSize: CGFloat(PreferenceManager.getFontSize()))
        cell.name.text = i.name
        cell.vendorName.text = i.manufacturerName
        cell.inventory.text = String(describing: i.units)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        inventoryItem = InventoryManager.getItem(index: indexPath.row)
        self.performSegue(withIdentifier: "detailView", sender: self)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            InventoryManager.delete(index: indexPath.row)
            tableViewMain.reloadData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailView",
            let destinationController = segue.destination as? DetailViewController {
            destinationController.inventoryItem = inventoryItem
        }
    }

}

