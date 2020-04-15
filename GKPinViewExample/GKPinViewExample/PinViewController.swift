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
    
    func pinViewDidTapBottomLeftButton(pinView: PinView) {
        dismiss(animated: true, completion: nil)
    }
    
    func pinView(pinView: PinView, enteredPin: String, isCorrectPinBlock: @escaping (_ isCorrect: Bool) -> ()) {
        DispatchQueue.global(qos: .background).async {
            // do a network request to check pin, or just check locally async in the background
            sleep(2)
            DispatchQueue.main.async {
                // execute isValidPinBlock on the main thread
                isCorrectPinBlock(enteredPin == "1234")
            }
        }
    }
    
    func pinViewDidSucceed(pinView: PinView) {
        dismiss(animated: true, completion: nil)
    }
    
    func pinViewDidFailWithIncorrectPin(pinView: PinView) {
        pinView.title = "Incorrect passcode, please try again"
    }
    
}
