//
//  PinView.swift
//  GKPinViewExample
//
//  Created by Gligor Kotushevski on 31/07/17.
//  Copyright © 2017 Gligor Kotushevski. All rights reserved.
//

import UIKit

public protocol PinViewDelegate: class {

    /**
     Function gets called when the user taps the `Cancel` button on the PinView
     
     - Parameters:
        - pinView: The `PinView` that called the delegate function
     */
    func pinViewDidTapCancel(pinView: PinView)
    
    /**
     Function gets called when the user ends entering the 4 digit pin
     
     - Parameters:
        - pinView: The `PinView` that called the delegate function
        - enteredPin: The 4 digit pin the user has entered as a `String`
        - isCorrectPinBlock: An escaping closure/block that takes an `isCorrect` boolean parameter
        - isCorrect: The boolean that tells the `PinView` whether or not the entered pin is correct/valid
     */
    func pinView(pinView: PinView, enteredPin: String, isCorrectPinBlock: @escaping (_ isCorrect: Bool) -> ())
    
    /**
     Function gets called when the user ends entering the 4 digit pin and the pin has been identified as a correct/valid pin
     
     - Parameters:
        - pinView: The `PinView` that called the delegate function
     */
    func pinViewDidSucceed(pinView: PinView)
    
    /**
     Function gets called when the user ends entering the 4 digit pin and the pin has been identified as an incorrect/invalid pin
     
     - Parameters:
        - pinView: The `PinView` that called the delegate function
     */
    func pinViewDidFailWithIncorrectPin(pinView: PinView)
}

@IBDesignable
public final class PinView: UIView {
    
    // MARK: - Outlets
    @IBOutlet weak var rootView: UIView!
    @IBOutlet weak var visualEffectBackground: UIVisualEffectView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var pinBubbleOne: PinBubble!
    @IBOutlet weak var pinBubbleTwo: PinBubble!
    @IBOutlet weak var pinBubbleThree: PinBubble!
    @IBOutlet weak var pinBubbleFour: PinBubble!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var buttonOne: PinButton!
    @IBOutlet weak var buttonTwo: PinButton!
    @IBOutlet weak var buttonThree: PinButton!
    @IBOutlet weak var buttonFour: PinButton!
    @IBOutlet weak var buttonFive: PinButton!
    @IBOutlet weak var buttonSix: PinButton!
    @IBOutlet weak var buttonSeven: PinButton!
    @IBOutlet weak var buttonEight: PinButton!
    @IBOutlet weak var buttonNine: PinButton!
    @IBOutlet weak var buttonZero: PinButton!
    
    // MARK: - IBInspectables
    /**
     The title showing at the top of the `PinView`
     */
    @IBInspectable public var title: String = "Enter Passcode" {
        didSet {
            titleLabel.text = title
        }
    }
    
    /**
     The boolean value specifying whether or not the `PinView` will have a blurred background or not
    */
    @IBInspectable public var blurBackground: Bool = false {
        didSet {
            visualEffectBackground.isHidden = !blurBackground
        }
    }
    
    @IBInspectable public var fontName: String = "System" {
        didSet {
            // font size is not important so we just init the font with size 10
            updateKeypadFont(UIFont(name: fontName, size: 10) ?? UIFont.boldSystemFont(ofSize: 10))
        }
    }
    
    @IBInspectable public var lettersFontName: String = "System" {
        didSet {
            // font size is not important so we just init the font with size 10
            updateLettersFont(UIFont(name: fontName, size: 10) ?? UIFont.systemFont(ofSize: 10))
        }
    }
    
    /**
     The color that controls the color of the pin bubbles
     */
    @IBInspectable public var bubblesTintColor: UIColor! {
        didSet {
            updateViewsTintColor()
        }
    }
    
    /**
     The color that controls the color of the `PinView` elements
     */
    @IBInspectable public override var tintColor: UIColor! {
        didSet {
            updateViewsTintColor()
        }
    }
    
    // MARK: - Other properties
    /**
     The blur background effect style that will be applied, if and only if `blurBackground` property is set to `true`
    */
    public var blurBackgroundEffectStyle: UIBlurEffectStyle = .dark {
        didSet {
            visualEffectBackground.effect = UIBlurEffect(style: blurBackgroundEffectStyle)
        }
    }
    
    // MARK: - State
    fileprivate var enteredPin = "" {
        didSet {
            if let delegate = delegate, enteredPin.length == 4 {
                showLoading()
                delegate.pinView(pinView: self, enteredPin: enteredPin, isCorrectPinBlock: { (isCorrect: Bool) in
                    // force execute block on the main thread (as these functions change the UI), in case the user didn't do this
                    DispatchQueue.main.async {
                        if isCorrect {
                            delegate.pinViewDidSucceed(pinView: self)
                        } else {
                            self.resetPinViewState()
                            self.shakeBubbles()
                            delegate.pinViewDidFailWithIncorrectPin(pinView: self)
                        }
                    }
                })
            }
            updateBubbles()
        }
    }
    
    // MARK: - Delegate
    public weak var delegate: PinViewDelegate?
    
    // MARK: - Initialisers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    /**
     This function will reset the entered pin and hide the loading indicator
     */
    public func resetPinViewState() {
        self.enteredPin = ""
        self.updateBubbles()
        self.hideLoading()
    }

}

private extension PinView {
    
    func setupView() {
        // make self background color clear
        backgroundColor = .clear
        // init and add view from nib
        let view = viewFromNib()
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        // update views tint color to the self.tintColor
        updateViewsTintColor()
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
    
    func updateViewsTintColor() {
        for subview in rootView.subviews {
            subview.tintColor = tintColor
        }
        titleLabel.textColor = tintColor
        pinBubbleOne.tintColor = bubblesTintColor
        pinBubbleTwo.tintColor = bubblesTintColor
        pinBubbleThree.tintColor = bubblesTintColor
        pinBubbleFour.tintColor = bubblesTintColor
    }
    
    func updateKeypadFont(_ font: UIFont) {
        var boldFont = font
        if let fontDescriptor = font.fontDescriptor.withSymbolicTraits(.traitBold) {
            boldFont = UIFont(descriptor: fontDescriptor, size: 10)
        }
        
        buttonOne.digitFont = font
        buttonTwo.digitFont = font
        buttonThree.digitFont = font
        buttonFour.digitFont = font
        buttonFive.digitFont = font
        buttonSix.digitFont = font
        buttonSeven.digitFont = font
        buttonEight.digitFont = font
        buttonNine.digitFont = font
        buttonZero.digitFont = font
        cancelButton.titleLabel?.font = font.withSize(cancelButton.titleLabel?.font.pointSize ?? 11)
        titleLabel.font = boldFont.withSize(titleLabel.font.pointSize)
    }
    
    func updateLettersFont(_ font: UIFont) {
        buttonOne.lettersFont = font
        buttonTwo.lettersFont = font
        buttonThree.lettersFont = font
        buttonFour.lettersFont = font
        buttonFive.lettersFont = font
        buttonSix.lettersFont = font
        buttonSeven.lettersFont = font
        buttonEight.lettersFont = font
        buttonNine.lettersFont = font
        buttonZero.lettersFont = font
    }
    
    // MARK: IBActions
    @IBAction func cancelTapped(_ sender: UIButton) {
        delegate?.pinViewDidTapCancel(pinView: self)
    }
    
    @IBAction func backspaceTapped(_ sender: UIButton) {
        if enteredPin.length > 0 {
            enteredPin.removeLastCharacter()
        }
    }
    
    @IBAction func keypadTapped(_ sender: PinButton) {
        if enteredPin.length < 4 {
            enteredPin = "\(enteredPin)\(sender.digit)"
        }
    }
    
    func updateBubbles() {
        switch enteredPin.length {
        case 0:
            pinBubbleOne.isFilled = false
            pinBubbleTwo.isFilled = false
            pinBubbleThree.isFilled = false
            pinBubbleFour.isFilled = false
        case 1:
            pinBubbleOne.isFilled = true
            pinBubbleTwo.isFilled = false
            pinBubbleThree.isFilled = false
            pinBubbleFour.isFilled = false
        case 2:
            pinBubbleOne.isFilled = true
            pinBubbleTwo.isFilled = true
            pinBubbleThree.isFilled = false
            pinBubbleFour.isFilled = false
        case 3:
            pinBubbleOne.isFilled = true
            pinBubbleTwo.isFilled = true
            pinBubbleThree.isFilled = true
            pinBubbleFour.isFilled = false
        case 4:
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
    
    func showLoading() {
        titleLabel.isHidden = true
        loadingIndicator.isHidden = false
    }
    
    func hideLoading() {
        loadingIndicator.isHidden = true
        titleLabel.isHidden = false
    }
    
    func shakeBubbles() {
        pinBubbleOne.shake()
        pinBubbleTwo.shake()
        pinBubbleThree.shake()
        pinBubbleFour.shake()
    }
    
    func hideCancelButton() {
        cancelButton.isHidden = true
    }
    
}

private extension String {
    
    var length: Int {
        return self.characters.count
    }
    
    mutating func removeLastCharacter() {
        self.remove(at: self.index(before: self.endIndex))
    }
    
}
