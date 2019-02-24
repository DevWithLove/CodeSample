//
//  CircleView.swift
//  ViewDiagram
//
//  Created by Tony Mu on 23/02/19.
//  Copyright © 2019 Tony Mu. All rights reserved.
//

import UIKit

@IBDesignable
public class CircleView: UIView {
    
    @IBInspectable
    public var fillColor: UIColor {
        didSet {
            self.layoutSubviews()
            self.layoutIfNeeded()
        }
    }
    
    public override init(frame: CGRect) {
        self.fillColor = UIColor.lightText
        
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
    }
    
    public required init?(coder aDecoder: NSCoder) {
        self.fillColor = UIColor.lightText
        
        super.init(coder: aDecoder)
        self.backgroundColor = UIColor.clear
    }
    
    
    public var shapeLayer: CAShapeLayer {
        get {
            return self.layer as! CAShapeLayer
        }
    }
    
    //Returns the class used to create the layer for instances of this class.
    public override class var layerClass: AnyClass {
        return CAShapeLayer.self
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        // after the super.layoutSuperviews() , we know the self.bounds
        let bezierPath = UIBezierPath(ovalIn: self.bounds)
        
        self.shapeLayer.fillColor = self.fillColor.cgColor
        self.shapeLayer.path = bezierPath.cgPath
    }
    
    
}
