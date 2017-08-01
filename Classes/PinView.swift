//
//  PinView.swift
//  GKPinViewExample
//
//  Created by Gligor Kotushevski on 31/07/17.
//  Copyright © 2017 Gligor Kotushevski. All rights reserved.
//

import UIKit

@IBDesignable
final class PinView: UIView {
    
    // MARK: - Outlets
    @IBOutlet weak var rootView: UIView!
    @IBOutlet weak var pinBubbleOne: PinBubble!
    @IBOutlet weak var pinBubbleTwo: PinBubble!
    @IBOutlet weak var pinBubbleThree: PinBubble!
    @IBOutlet weak var pinBubbleFour: PinBubble!
    
    // MARK: - IBInspectables
    
    // MARK: - State
    fileprivate var digitsRemaining = 4
    
    // MARK: - Initialisers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

}

private extension PinView {
    
    func setupView() {
        let view = viewFromNib()
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(view)
    }
    
    func viewFromNib() -> UIView {
        let bundle = Bundle(for: PinView.self)
        let nib = UINib(nibName: String(describing: PinView.self), bundle: bundle)
        if let view = nib.instantiate(withOwner: self, options: nil).first as? UIView {
            return view
        }
        fatalError("Could not initialise PinView from nib.")
    }
    
    // MARK: IBActions
    @IBAction func keypadTapped(_ sender: PinButton) {
        if digitsRemaining > 0 {
            digitsRemaining -= 1
            fillBubbles()
        }
    }
    
    func fillBubbles() {
        switch digitsRemaining {
        case 4:
            pinBubbleOne.isFilled = false
            pinBubbleTwo.isFilled = false
            pinBubbleThree.isFilled = false
            pinBubbleFour.isFilled = false
        case 3:
            pinBubbleOne.isFilled = true
            pinBubbleTwo.isFilled = false
            pinBubbleThree.isFilled = false
            pinBubbleFour.isFilled = false
        case 2:
            pinBubbleOne.isFilled = true
            pinBubbleTwo.isFilled = true
            pinBubbleThree.isFilled = false
            pinBubbleFour.isFilled = false
        case 1:
            pinBubbleOne.isFilled = true
            pinBubbleTwo.isFilled = true
            pinBubbleThree.isFilled = true
            pinBubbleFour.isFilled = false
        case 0:
            pinBubbleOne.isFilled = true
            pinBubbleTwo.isFilled = true
            pinBubbleThree.isFilled = true
            pinBubbleFour.isFilled = true
        default:
            assert(false, "Only values between 0-4 are valid")
        }
        pinBubbleOne.setNeedsDisplay()
        pinBubbleTwo.setNeedsDisplay()
        pinBubbleThree.setNeedsDisplay()
        pinBubbleFour.setNeedsDisplay()
    }
    
}