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
    
    override var tintColor: UIColor! {
        didSet {
            digitLabel.textColor = tintColor
            lettersLabel.textColor = tintColor
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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // button target action
        addTarget(self, action: #selector(onTap), for: .touchUpInside)
    }
    
    dynamic private func onTap() {
        animateTap()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        addSubview(digitLabel)
        addSubview(lettersLabel)
        
        // digit label customisations
        digitLabel.textColor = tintColor
        digitLabel.font = keypadFont.withSize(PinButton.digitFontSize)
        digitLabel.textAlignment = .center
        
        // letters flabel customisations
        lettersLabel.textColor = tintColor
        lettersLabel.font = keypadFont.withSize(PinButton.lettersFontSize)
        lettersLabel.textAlignment = .center
            
        // digit and letters labels frames
        if hideKeypadLetters || digit == 0 { // always center the 0, so it aligns with the backspace button
            digitLabel.frame = bounds
            lettersLabel.frame = CGRect.zero
        } else {
            digitLabel.frame = CGRect(origin: bounds.origin, size: CGSize(width: bounds.width, height: bounds.height - PinButton.lettersLabelHeight))
            lettersLabel.frame = CGRect(origin: CGPoint(x: bounds.origin.x, y: digitLabel.frame.height), size: CGSize(width: bounds.width, height: bounds.height - digitLabel.frame.height))
        }
    }
    
}
