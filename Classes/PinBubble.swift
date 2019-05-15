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
    
    @IBInspectable var borderSize: CGFloat = 1 {
        didSet {
            draw(bounds)
        }
    }
    
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
        if isFilled {
            tintColor.setFill()
        } else {
            tintColor.withAlphaComponent(0.7).setFill()
        }
        borderLayer.fill()
        
        let fillLayer = UIBezierPath(ovalIn: CGRect(x: borderSize, y: borderSize, width: bounds.width - borderSize * 2, height: bounds.height - borderSize * 2))
        if isFilled {
            tintColor.setFill()
        } else {
            UIColor.clear.setFill()
        }
        fillLayer.fill(with: .destinationAtop, alpha: 1)
    }
    
    func shake(_ completion: ((Bool) -> Void)? = nil) {
        self.transform = CGAffineTransform(translationX: 16, y: 0)
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
            self.transform = CGAffineTransform.identity
        }, completion: completion)
    }

}
