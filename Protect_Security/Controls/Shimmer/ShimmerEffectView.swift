//
//  ShimmerEffectView.swift
//  Protect_Security
//
//  Created by Harish Chandra Singh on 10/01/2019.
//  Copyright © 2019 Jatin Garg. All rights reserved.
//

import UIKit

class ShimmerEffectView: View {
    
    @IBOutlet weak var imageDown: UIView!
    @IBOutlet weak var imageUp: UIView!
    @IBOutlet weak var titleDown: UIView!
    @IBOutlet weak var titleUp: UIView!
    @IBOutlet weak var descDown: UIView!
    @IBOutlet weak var descUp: UIView!
    
    override func setup() {
        loadNib(named: "ShimmerEffectView")
    }
    
    public func startShimmering() {
        animationWithviews(firstView: imageDown, secondView: imageUp)
        animationWithviews(firstView: titleDown, secondView: titleUp)
        animationWithviews(firstView: descDown, secondView: descUp)
    }
    
    public func animationWithviews(firstView: UIView, secondView: UIView) {
        
        firstView.layer.cornerRadius = 4
        secondView.layer.cornerRadius = 4
            
        firstView.backgroundColor = UIColor.lightGray
        secondView.backgroundColor = UIColor.gray
        
        let gradientlayer = CAGradientLayer()
        gradientlayer.colors = [UIColor.clear.cgColor, UIColor.white.withAlphaComponent(0.5).cgColor, UIColor.clear.cgColor]
        gradientlayer.locations = [0,0.5,1]
        gradientlayer.frame = secondView.bounds
        
        let angle = -90*CGFloat.pi/180
        gradientlayer.transform = CATransform3DMakeRotation(angle, 0, 0, 1)
        secondView.layer.mask = gradientlayer
        
        //animation
        let animation = CABasicAnimation(keyPath: "transform.translation.x")
        animation.duration = 1.0
        animation.fromValue = -secondView.frame.width
        animation.toValue = secondView.frame.width
        animation.repeatCount = Float.infinity
        gradientlayer.add(animation, forKey:  "transform.translation.x")
    }
}
