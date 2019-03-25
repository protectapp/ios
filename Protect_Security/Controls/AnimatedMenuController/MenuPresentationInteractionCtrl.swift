//
//  MenuPresentationInteractionCtrl.swift
//  CircularMenuTransition
//
//  Created by Jatin Garg on 13/12/18.
//  Copyright © 2018 Jatin Garg. All rights reserved.
//

import UIKit

class MenuPresentationInteractionController: UIPercentDrivenInteractiveTransition {
    private weak var viewController: UIViewController?
    private weak var menu: UIViewController?
    public var animationInProgress: Bool = false
    public var shouldCompleteAnimation: Bool = false
    
    init(viewController: UIViewController, menu: UIViewController) {
        super.init()
        self.viewController = viewController
        self.menu = menu
        configurePanGesture()
    }
    
    private func configurePanGesture() {
        let edge = UIScreenEdgePanGestureRecognizer(target: self,
                                                    action: #selector(self.handleEdgePan(_:)))
        edge.edges = .left
        viewController?.view.addGestureRecognizer(edge)
    }
    
    @objc func handleEdgePan(_ gesture: UIPanGestureRecognizer) {
        let translate = gesture.translation(in: gesture.view)
        let percent = translate.x / gesture.view!.bounds.size.width
        
        switch gesture.state {
        case .began:
            animationInProgress = true
            viewController?.present(menu!, animated: true)
        case .changed:
            shouldCompleteAnimation = percent > 0.5 || gesture.velocity(in: gesture.view).x > 0
            update(percent)
        case .ended:
            shouldCompleteAnimation ? finish() : cancel()
            animationInProgress = false
        case .cancelled:
            animationInProgress = false
            cancel()
            
        default:
            break
        }
    }
}
