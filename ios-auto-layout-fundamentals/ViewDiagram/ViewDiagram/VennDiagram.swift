//
//  VennDiagram.swift
//  ViewDiagram
//
//  Created by Tony Mu on 23/02/19.
//  Copyright © 2019 Tony Mu. All rights reserved.
//

import UIKit

enum VennWeight {
    case Left
    case Balanced
    case Right
}

class VennDiagram: UIView {
    
    @IBOutlet weak var leftCircleTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var leftCircleLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var leftCircleBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var rightCircleTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var rightCircleTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var rightCircleBottomConstraint: NSLayoutConstraint!
    
    var weight: VennWeight = .Balanced {
        didSet {
            self.setNeedsUpdateConstraints()
        }
    }
    
    override func awakeFromNib() {
        let view = UIView()
        view.frame = self.bounds
        view.backgroundColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0)
        view.layer.cornerRadius = 12.0
        view.autoresizingMask = [
            UIView.AutoresizingMask.flexibleWidth,
            UIView.AutoresizingMask.flexibleHeight
        ]
        
       // view.translatesAutoresizingMaskIntoConstraints = false
        
        self.insertSubview(view, at: 0)
    }
    
    override func updateConstraints() {
        
        switch self.weight {
        case .Left:
            self.leftCircleBottomConstraint.constant = 20
            self.leftCircleLeadingConstraint.constant = 20
            self.leftCircleTopConstraint.constant = 20
            
            self.rightCircleBottomConstraint.constant = 40
            self.rightCircleTrailingConstraint.constant = 40
            self.rightCircleTopConstraint.constant = 40
        case .Balanced:
            self.leftCircleBottomConstraint.constant = 20
            self.leftCircleLeadingConstraint.constant = 20
            self.leftCircleTopConstraint.constant = 20
            
            self.rightCircleBottomConstraint.constant = 20
            self.rightCircleTrailingConstraint.constant = 20
            self.rightCircleTopConstraint.constant = 20
        case .Right:
            self.leftCircleBottomConstraint.constant = 40
            self.leftCircleLeadingConstraint.constant = 40
            self.leftCircleTopConstraint.constant = 40
            
            self.rightCircleBottomConstraint.constant = 20
            self.rightCircleTrailingConstraint.constant = 20
            self.rightCircleTopConstraint.constant = 20
        }
        
        super.updateConstraints()
    }
}

