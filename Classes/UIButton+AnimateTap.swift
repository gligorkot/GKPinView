//
//  UIButton+AnimateTap.swift
//  GKPinViewExample
//
//  Created by Gligor Kotushevski on 2/08/17.
//  Copyright © 2017 Gligor Kotushevski. All rights reserved.
//

extension UIButton {
    
    func animateTap() {
        // add ripple subview
        let ripple = UIView(frame: bounds)
        ripple.backgroundColor = tintColor.withAlphaComponent(0.3)
        ripple.layer.cornerRadius = ripple.bounds.size.height / 2
        ripple.isUserInteractionEnabled = false
        addSubview(ripple)
        
        // add stationary circle
        let stationaryCircle = UIView(frame: bounds.insetBy(dx: bounds.width * (-0.2), dy: bounds.height * (-0.2)))
        stationaryCircle.backgroundColor = tintColor.withAlphaComponent(0.3)
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
        opacityAnimation.fillMode = CAMediaTimingFillMode.forwards
        
        // run both scale and opacity animations in a group for ripple layer
        let rippleAnimation = CAAnimationGroup()
        rippleAnimation.duration = 0.6
        rippleAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        rippleAnimation.isRemovedOnCompletion = false
        rippleAnimation.fillMode = CAMediaTimingFillMode.forwards
        rippleAnimation.animations = [scaleAnimation, opacityAnimation]
        
        // add animations to layers
        ripple.layer.add(rippleAnimation, forKey: "rippleLayer")
        stationaryCircle.layer.add(opacityAnimation, forKey: "stationaryCircleLayer")
        
        // commit CAAnimation Transaction
        CATransaction.commit()
    }
    
}
