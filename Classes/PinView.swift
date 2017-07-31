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
    
    // MARK: - IBInspectables
    
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
    
}
