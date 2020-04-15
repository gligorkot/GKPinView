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
    The bottom left button title
    */
    var bottomLeftButtonTitle: String { get }

    /**
     Function gets called when the user taps the bottom left button on the PinView

     - Parameters:
        - pinView: The `PinView` that called the delegate function
     */
    func pinViewDidTapBottomLeftButton(pinView: PinView)

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
    @IBOutlet weak var titleLabelHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var pinBubbleOne: PinBubble!
    @IBOutlet weak var pinBubbleTwo: PinBubble!
    @IBOutlet weak var pinBubbleThree: PinBubble!
    @IBOutlet weak var pinBubbleFour: PinBubble!
    @IBOutlet weak var bottomLeftButton: UIButton!
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
     The height of the title showing at the top of the `PinView`
     */
    @IBInspectable public var titleHeight: CGFloat = 21 {
        didSet {
            titleLabelHeightConstraint.constant = titleHeight
        }
    }
    
    /**
     The font of the title showing at the top of the `PinView`
     */
    @IBInspectable public var titleFontName: String = "System" {
        didSet {
            updateTitleFont()
        }
    }
    
    /**
     The font size of the title showing at the top of the `PinView`
     */
    @IBInspectable public var titleFontSize: CGFloat = 20 {
        didSet {
            updateTitleFont()
        }
    }
    
    /**
     The color that controls the color of the title showing at the top of the `PinView`
     */
    @IBInspectable public var titleTintColor: UIColor = .white {
        didSet {
            titleLabel.textColor = titleTintColor
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
    
    @IBInspectable public var keypadFontSize: CGFloat = 30 {
        didSet {
            // font size is not important so we just init the font with size 10
            updateKeypadFont(UIFont(name: fontName, size: 10) ?? UIFont.boldSystemFont(ofSize: 10))
        }
    }

    @IBInspectable public var lettersFontName: String = "System" {
        didSet {
            // font size is not important so we just init the font with size 10
            updateLettersFont(UIFont(name: lettersFontName, size: 10) ?? UIFont.systemFont(ofSize: 10))
        }
    }
    
    /**
     The boolean value specifying whether or not the keypad buttons will show letters or not
     */
    @IBInspectable public var hideKeypadLetters: Bool = false {
        didSet {
            updateKeypadLettersVisible()
        }
    }
    
    /**
     The boolean value specifying whether or not the default pin view loading indicator will be shown or not
     */
    @IBInspectable public var hideDefaultLoadingIndicator: Bool = false

    /**
     The color that controls the color of the pin bubbles
     */
    @IBInspectable public var bubblesTintColor: UIColor! {
        didSet {
            updateViewsTintColor()
        }
    }
    
    /**
     The width and height of the pin bubbles
     */
    @IBInspectable public var bubblesBorderSize: CGFloat = 1 {
        didSet {
            updateBubblesConstraints()
        }
    }
    
    /**
     The width and height of the pin bubbles
     */
    @IBInspectable public var bubblesSize: CGFloat = 12 {
        didSet {
            updateBubblesConstraints()
        }
    }
    
    /**
     The margin between the pin bubbles
     */
    @IBInspectable public var bubblesMargin: CGFloat = 15 {
        didSet {
            updateBubblesConstraints()
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
    public var blurBackgroundEffectStyle: UIBlurEffect.Style = .dark {
        didSet {
            visualEffectBackground.effect = UIBlurEffect(style: blurBackgroundEffectStyle)
        }
    }

    // MARK: - State
    private var enteredPin = "" {
        didSet {
            if let delegate = delegate, enteredPin.length == 4 {
                showLoading()
                DispatchQueue.global(qos: .userInitiated).async {
                    delegate.pinView(pinView: self, enteredPin: self.enteredPin, isCorrectPinBlock: { (isCorrect: Bool) in
                        // force execute block on the main thread (as these functions change the UI), in case the user didn't do this
                        DispatchQueue.main.async {
                            if isCorrect {
                                delegate.pinViewDidSucceed(pinView: self)
                            } else {
                                self.shakeBubbles() { _ in
                                    self.resetPinViewState()
                                    delegate.pinViewDidFailWithIncorrectPin(pinView: self)
                                }
                            }
                        }
                    })
                }
            }
            updateBubbles()
            updateBottomLeftButton()
        }
    }

    // MARK: - Delegate
    public weak var delegate: PinViewDelegate? {
        didSet {
            updateBottomLeftButton()
        }
    }

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

    /**
     This function will hide the bottom left button from the pin view
     */
    public func hideBottomLeftButton() {
        bottomLeftButton.isHidden = true
    }
    
    // constraints
    private var pinBubbleOneWidthConstraint: NSLayoutConstraint!
    private var pinBubbleOneHeightConstraint: NSLayoutConstraint!
    private var pinBubbleTwoWidthConstraint: NSLayoutConstraint!
    private var pinBubbleTwoHeightConstraint: NSLayoutConstraint!
    private var pinBubbleThreeWidthConstraint: NSLayoutConstraint!
    private var pinBubbleThreeHeightConstraint: NSLayoutConstraint!
    private var pinBubbleFourWidthConstraint: NSLayoutConstraint!
    private var pinBubbleFourHeightConstraint: NSLayoutConstraint!
    private var pinBubbleOneMarginConstraint: NSLayoutConstraint!
    private var pinBubbleTwoMarginConstraint: NSLayoutConstraint!
    private var pinBubbleThreeMarginConstraint: NSLayoutConstraint!
    private var pinBubbleFourMarginConstraint: NSLayoutConstraint!

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
        // init bubble constraints
        pinBubbleOneWidthConstraint = pinBubbleOne.widthAnchor.constraint(equalToConstant: bubblesSize)
        pinBubbleOneHeightConstraint = pinBubbleOne.heightAnchor.constraint(equalToConstant: bubblesSize)
        pinBubbleTwoWidthConstraint = pinBubbleTwo.widthAnchor.constraint(equalToConstant: bubblesSize)
        pinBubbleTwoHeightConstraint = pinBubbleTwo.heightAnchor.constraint(equalToConstant: bubblesSize)
        pinBubbleThreeWidthConstraint = pinBubbleThree.widthAnchor.constraint(equalToConstant: bubblesSize)
        pinBubbleThreeHeightConstraint = pinBubbleThree.heightAnchor.constraint(equalToConstant: bubblesSize)
        pinBubbleFourWidthConstraint = pinBubbleFour.widthAnchor.constraint(equalToConstant: bubblesSize)
        pinBubbleFourHeightConstraint = pinBubbleFour.heightAnchor.constraint(equalToConstant: bubblesSize)
        NSLayoutConstraint.activate([
            pinBubbleOneWidthConstraint,
            pinBubbleOneHeightConstraint,
            pinBubbleTwoWidthConstraint,
            pinBubbleTwoHeightConstraint,
            pinBubbleThreeWidthConstraint,
            pinBubbleThreeHeightConstraint,
            pinBubbleFourWidthConstraint,
            pinBubbleFourHeightConstraint
            ])
        let centerXDiff = (bubblesMargin / 2) + (bubblesSize / 2)
        pinBubbleOneMarginConstraint = pinBubbleOne.trailingAnchor.constraint(equalTo: pinBubbleTwo.leadingAnchor, constant: -bubblesMargin)
        pinBubbleTwoMarginConstraint = pinBubbleTwo.centerXAnchor.constraint(equalTo: rootView.centerXAnchor, constant: -centerXDiff)
        pinBubbleThreeMarginConstraint = pinBubbleThree.centerXAnchor.constraint(equalTo: rootView.centerXAnchor, constant: centerXDiff)
        pinBubbleFourMarginConstraint = pinBubbleFour.leadingAnchor.constraint(equalTo: pinBubbleThree.trailingAnchor, constant: bubblesMargin)
        NSLayoutConstraint.activate([
            pinBubbleOneMarginConstraint,
            pinBubbleTwoMarginConstraint,
            pinBubbleThreeMarginConstraint,
            pinBubbleFourMarginConstraint
            ])
    }

    func viewFromNib() -> UIView {
        let bundle = Bundle(for: PinView.self)
        let nib = UINib(nibName: String(describing: PinView.self), bundle: bundle)
        if let view = nib.instantiate(withOwner: self, options: nil).first as? UIView {
            return view
        }
        fatalError("Could not initialise PinView from nib.")
    }
    
    func updateTitleFont() {
        var boldFont = UIFont(name: titleFontName, size: titleFontSize) ?? UIFont.boldSystemFont(ofSize: titleFontSize)
        if let fontDescriptor = boldFont.fontDescriptor.withSymbolicTraits(.traitBold) {
            boldFont = UIFont(descriptor: fontDescriptor, size: titleFontSize)
        }
        titleLabel.font = boldFont
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
        buttonOne.digitFontSize = keypadFontSize
        buttonTwo.digitFontSize = keypadFontSize
        buttonThree.digitFontSize = keypadFontSize
        buttonFour.digitFontSize = keypadFontSize
        buttonFive.digitFontSize = keypadFontSize
        buttonSix.digitFontSize = keypadFontSize
        buttonSeven.digitFontSize = keypadFontSize
        buttonEight.digitFontSize = keypadFontSize
        buttonNine.digitFontSize = keypadFontSize
        buttonZero.digitFontSize = keypadFontSize
        titleLabel.font = boldFont.withSize(titleLabel.font.pointSize)
        updateBottomLeftButton()
    }
    
    func updateBottomLeftButton() {
        if let bottomLeftButtonTitle = delegate?.bottomLeftButtonTitle {
            let fontSize = bottomLeftButton.titleLabel?.font.pointSize ?? 11
            let font = UIFont(name: fontName, size: fontSize) ?? UIFont.boldSystemFont(ofSize: fontSize)
            let paragraph = NSMutableParagraphStyle()
            paragraph.alignment = .center
            bottomLeftButton.setAttributedTitle(NSAttributedString(string: bottomLeftButtonTitle, attributes: [.font : font, .paragraphStyle : paragraph]), for: .normal)
        }
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
    
    func updateKeypadLettersVisible() {
        buttonOne.hideKeypadLetters = hideKeypadLetters
        buttonTwo.hideKeypadLetters = hideKeypadLetters
        buttonThree.hideKeypadLetters = hideKeypadLetters
        buttonFour.hideKeypadLetters = hideKeypadLetters
        buttonFive.hideKeypadLetters = hideKeypadLetters
        buttonSix.hideKeypadLetters = hideKeypadLetters
        buttonSeven.hideKeypadLetters = hideKeypadLetters
        buttonEight.hideKeypadLetters = hideKeypadLetters
        buttonNine.hideKeypadLetters = hideKeypadLetters
        buttonZero.hideKeypadLetters = hideKeypadLetters
    }

    // MARK: IBActions
    @IBAction func bottomLeftTapDown(_ sender: UIButton) {
        sender.animateTap()
    }

    @IBAction func bottomLeftTapped(_ sender: UIButton) {
        delegate?.pinViewDidTapBottomLeftButton(pinView: self)
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
    
    func updateBubblesConstraints() {
        // border size
        pinBubbleOne.borderSize = bubblesBorderSize
        pinBubbleTwo.borderSize = bubblesBorderSize
        pinBubbleThree.borderSize = bubblesBorderSize
        pinBubbleFour.borderSize = bubblesBorderSize
        
        // width and height
        pinBubbleOneWidthConstraint.constant = bubblesSize
        pinBubbleOneHeightConstraint.constant = bubblesSize
        pinBubbleTwoWidthConstraint.constant = bubblesSize
        pinBubbleTwoHeightConstraint.constant = bubblesSize
        pinBubbleThreeWidthConstraint.constant = bubblesSize
        pinBubbleThreeHeightConstraint.constant = bubblesSize
        pinBubbleFourWidthConstraint.constant = bubblesSize
        pinBubbleFourHeightConstraint.constant = bubblesSize
        
        // margin
        let centerXDiff = (bubblesMargin / 2) + (bubblesSize / 2)
        pinBubbleOneMarginConstraint.constant = -bubblesMargin
        pinBubbleTwoMarginConstraint.constant = -centerXDiff
        pinBubbleThreeMarginConstraint.constant = centerXDiff
        pinBubbleFourMarginConstraint.constant = bubblesMargin
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
        if !hideDefaultLoadingIndicator {
            loadingIndicator.isHidden = false
        }
    }

    func hideLoading() {
        if !hideDefaultLoadingIndicator {
            loadingIndicator.isHidden = true
        }
        titleLabel.isHidden = false
    }

    func shakeBubbles(_ completion: ((Bool) -> Void)? = nil) {
        pinBubbleOne.shake()
        pinBubbleTwo.shake()
        pinBubbleThree.shake()
        pinBubbleFour.shake(completion)
    }

}

private extension String {

    var length: Int {
        return self.count
    }
    
    mutating func removeLastCharacter() {
        self.remove(at: self.index(before: self.endIndex))
    }

}
