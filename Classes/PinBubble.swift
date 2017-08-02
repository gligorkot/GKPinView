//
//  PinBubble.swift
//  GKPinViewExample
//
//  Created by Gligor Kotushevski on 1/08/17.
//  Copyright © 2017 Gligor Kotushevski. All rights reserved.
//

import UIKit

@IBDesignable
final class PinBubble: UIView {
    
    private let borderSize: CGFloat = 1.5
    
    @IBInspectable var isFilled: Bool = false {
        didSet {
            draw(bounds)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .clear
    }

    override func draw(_ rect: CGRect) {
        let borderLayer = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height))
        tintColor.setFill()
        borderLayer.fill()
        
        let fillLayer = UIBezierPath(ovalIn: CGRect(x: borderSize, y: borderSize, width: bounds.width - borderSize * 2, height: bounds.height - borderSize * 2))
        if isFilled {
            tintColor.withAlphaComponent(0.7).setFill()
        } else {
            UIColor.clear.setFill()
        }
        fillLayer.fill(with: .destinationAtop, alpha: 1)
    }

}
