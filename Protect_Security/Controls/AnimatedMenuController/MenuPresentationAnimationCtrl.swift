//
//  MenuPresentationAnimationCtrl.swift
//  CircularMenuTransition
//
//  Created by Jatin Garg on 06/12/18.
//  Copyright © 2018 Jatin Garg. All rights reserved.
//

import UIKit

class MenuPresentationAnimationController: NSObject, UIViewControllerAnimatedTransitioning, CAAnimationDelegate {
    private var transitionDuration: TimeInterval
    private var context: UIViewControllerContextTransitioning!
    public var shouldDismiss: Bool = false
    
    init(transitionDuration: TimeInterval, shouldDismiss: Bool = false) {
        self.transitionDuration = transitionDuration
        self.shouldDismiss = shouldDismiss
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return transitionDuration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard
            let fromVC = transitionContext.viewController(forKey: .from),
            let toVC = transitionContext.viewController(forKey: .to)
            else{
                return
        }
        
        let toView = toVC.view!
        let fromView = fromVC.view!
        
        let container = transitionContext.containerView
        
        toView.frame = fromView.frame
        
        var viewTomask: UIView!
        if !shouldDismiss {
            container.addSubview(toView)
            viewTomask = toView
        }else{
            container.insertSubview(toView, belowSubview: fromView)
            viewTomask = fromView
        }
        
        
        let startingSize: CGFloat = 0
        let startingY: CGFloat = (UIScreen.main.bounds.height-startingSize)/2
        let frame1: CGRect = CGRect(x: 0, y: startingY, width: startingSize, height: startingSize)
        let path1 = UIBezierPath(arcCenter: frame1.origin, radius: startingSize, startAngle: CGFloat.pi/2, endAngle: CGFloat.pi * 3 / 2, clockwise: false)
        
        let path2StartPoint = frame1.origin
        let path2EndPoint = CGPoint(x: fromView.frame.width, y: 0)
        
        let xDistance = path2EndPoint.x - path2StartPoint.x
        let yDistance = path2EndPoint.y - path2StartPoint.y
        let path2Radius = sqrt(xDistance * xDistance + yDistance * yDistance )
        
        let path2 = UIBezierPath(arcCenter: frame1.origin, radius: path2Radius, startAngle: CGFloat.pi/2, endAngle: CGFloat.pi * 3 / 2, clockwise: false)
        
        let maskLayer = CAShapeLayer()
        viewTomask.layer.mask = maskLayer
        
        let animation = CABasicAnimation(keyPath: "path")
        animation.delegate = self
        animation.fromValue = shouldDismiss ? path2.cgPath : path1.cgPath
        animation.toValue = !shouldDismiss ? path2.cgPath : path1.cgPath
        animation.duration = transitionDuration
        animation.isRemovedOnCompletion = false
        animation.fillMode = kCAFillModeForwards
        maskLayer.add(animation, forKey: "waht")
        
        context = transitionContext
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        context.completeTransition(!context.transitionWasCancelled)
    }
    
}
