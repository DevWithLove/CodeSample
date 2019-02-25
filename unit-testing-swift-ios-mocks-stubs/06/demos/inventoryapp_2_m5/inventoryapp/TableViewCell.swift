//
//  TableViewCell.swift
//  inventoryapp
//
//  Created by Brett Romero on 1/4/17.
//  Copyright © 2017 test. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet var name: UILabel!
    @IBOutlet var vendorName: UILabel!
    @IBOutlet var inventory: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
