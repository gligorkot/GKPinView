//
//  PinButton.swift
//  GKPinViewExample
//
//  Created by Gligor Kotushevski on 1/08/17.
//  Copyright © 2017 Gligor Kotushevski. All rights reserved.
//

import UIKit

@IBDesignable
final class PinButton: UIButton {
    
    private static let digitFontSize: CGFloat = 35
    private static let lettersFontSize: CGFloat = 13
    private static let lettersLabelHeight: CGFloat = 25
    
    @IBInspectable var keypadColor: UIColor = .white {
        didSet {
            digitLabel.textColor = keypadColor
            lettersLabel.textColor = keypadColor
        }
    }
    
    @IBInspectable var keypadFont: UIFont = UIFont.systemFont(ofSize: UIFont.smallSystemFontSize) {
        didSet {
            digitLabel.font = keypadFont.withSize(PinButton.digitFontSize)
            lettersLabel.font = keypadFont.withSize(PinButton.lettersFontSize)
        }
    }
    
    @IBInspectable var hideKeypadLetters: Bool = false {
        didSet {
            if hideKeypadLetters {
                lettersLabel.text = nil
                layoutSubviews()
            }
        }
    }
    
    @IBInspectable var digit: Int = 0 {
        didSet {
            digitLabel.text = "\(digit)"
            if !hideKeypadLetters {
                switch digit {
                case 0, 1:
                    lettersLabel.text = nil
                case 2:
                    lettersLabel.text = "ABC"
                case 3:
                    lettersLabel.text = "DEF"
                case 4:
                    lettersLabel.text = "GHI"
                case 5:
                    lettersLabel.text = "JKL"
                case 6:
                    lettersLabel.text = "MNO"
                case 7:
                    lettersLabel.text = "PQRS"
                case 8:
                    lettersLabel.text = "TUV"
                case 9:
                    lettersLabel.text = "WXYZ"
                default:
                    assert(false, "Only accept values between 0-9")
                }
            }
            layoutSubviews()
        }
    }
    
    private let digitLabel: UILabel
    private let lettersLabel: UILabel
    
    override init(frame: CGRect) {
        digitLabel = UILabel()
        lettersLabel = UILabel()
        super.init(frame: frame)
        layoutSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        digitLabel = UILabel()
        lettersLabel = UILabel()
        super.init(coder: aDecoder)
        layoutSubviews()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        addSubview(digitLabel)
        addSubview(lettersLabel)
        
        // digit label customisations
        digitLabel.textColor = keypadColor
        digitLabel.font = keypadFont.withSize(PinButton.digitFontSize)
        digitLabel.textAlignment = .center
        
        // letters flabel customisations
        lettersLabel.textColor = keypadColor
        lettersLabel.font = keypadFont.withSize(PinButton.lettersFontSize)
        lettersLabel.textAlignment = .center
            
        // digit and letters labels frames
        if hideKeypadLetters {
            digitLabel.frame = bounds
            lettersLabel.frame = CGRect.zero
        } else {
            digitLabel.frame = CGRect(origin: bounds.origin, size: CGSize(width: bounds.width, height: bounds.height - PinButton.lettersLabelHeight))
            lettersLabel.frame = CGRect(origin: CGPoint(x: bounds.origin.x, y: digitLabel.frame.height), size: CGSize(width: bounds.width, height: bounds.height - digitLabel.frame.height))
        }
        
        // button frame and target action
        addTarget(self, action: #selector(onTap), for: .touchUpInside)
    }
    
    dynamic private func onTap() {
        animateTap()
    }
    
    private func animateTap() {
        // add ripple subview
        let ripple = UIView(frame: bounds)
        ripple.backgroundColor = UIColor.white.withAlphaComponent(0.3)
        ripple.layer.cornerRadius = ripple.bounds.size.height / 2
        ripple.isUserInteractionEnabled = false
        addSubview(ripple)
        
        // add stationary circle
        let stationaryCircle = UIView(frame: bounds.insetBy(dx: bounds.width * (-0.2), dy: bounds.height * (-0.2)))
        stationaryCircle.backgroundColor = UIColor.white.withAlphaComponent(0.3)
        stationaryCircle.layer.cornerRadius = stationaryCircle.bounds.size.height / 2
        stationaryCircle.isUserInteractionEnabled = false
        addSubview(stationaryCircle)
        
        // start CAAnimation Transaction
        CATransaction.begin()
        CATransaction.setCompletionBlock({
            // remove views once animation has completed
            ripple.removeFromSuperview()
            stationaryCircle.removeFromSuperview()
        })
        
        // prepare scale animation
        let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
        scaleAnimation.fromValue = 0.35
        scaleAnimation.toValue = 1.5
        
        // prepare opacity animation
        let opacityAnimation = CABasicAnimation(keyPath: "opacity")
        opacityAnimation.fromValue = 1.0
        opacityAnimation.toValue = 0.0
        opacityAnimation.isRemovedOnCompletion = false
        opacityAnimation.fillMode = kCAFillModeForwards
        
        // run both scale and opacity animations in a group for ripple layer
        let rippleAnimation = CAAnimationGroup()
        rippleAnimation.duration = 0.6
        rippleAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        rippleAnimation.isRemovedOnCompletion = false
        rippleAnimation.fillMode = kCAFillModeForwards
        rippleAnimation.animations = [scaleAnimation, opacityAnimation]
        
        // add animations to layers
        ripple.layer.add(rippleAnimation, forKey: "rippleLayer")
        stationaryCircle.layer.add(opacityAnimation, forKey: "stationaryCircleLayer")
        
        // commit CAAnimation Transaction
        CATransaction.commit()
    }
    
}
