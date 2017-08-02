//
//  PinViewController.swift
//  GKPinViewExample
//
//  Created by Gligor Kotushevski on 31/07/17.
//  Copyright © 2017 Gligor Kotushevski. All rights reserved.
//

import UIKit
import GKPinView

class PinViewController: UIViewController {

    @IBOutlet weak var pinView: PinView!
    
    class func getVC() -> PinViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle(for: PinViewController.self))
        let vc = storyboard.instantiateViewController(withIdentifier: "PinViewController") as! PinViewController
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pinView.delegate = self
    }

}

extension PinViewController: PinViewDelegate {
    
    func pinViewDidTapCancel(pinView: PinView) {
        dismiss(animated: true, completion: nil)
    }
    
}
