//
//  ExampleViewController.swift
//  GKPinViewExample
//
//  Created by Gligor Kotushevski on 2/08/17.
//  Copyright © 2017 Gligor Kotushevski. All rights reserved.
//

import UIKit

final class ExampleViewController: UIViewController {
    
    @IBAction func openPinScreenTapped(_ sender: UIButton) {
        let pinVC = PinViewController.getVC()
        present(pinVC, animated: true, completion: nil)
    }
    
}
