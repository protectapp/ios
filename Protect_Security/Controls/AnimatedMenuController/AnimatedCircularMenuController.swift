//
//  ViewController.swift
//  CircularMenuTransition
//
//  Created by Jatin Garg on 06/12/18.
//  Copyright © 2018 Jatin Garg. All rights reserved.
//

import UIKit

class AnimatedCircularMenuController: UIViewController {
    private var menuPresentationInteractionController: MenuPresentationInteractionController!
    
    private lazy var menuPresentationAnimationController: MenuPresentationAnimationController = {
        return MenuPresentationAnimationController(transitionDuration: 0.45)
    }()
    
    
    public var frontViewcontroller: UIViewController?
    public var rearViewcontroller: UIViewController?
    
    convenience init(frontViewcontroller: UIViewController, rearViewcontroller: UIViewController) {
        self.init()
        self.frontViewcontroller = frontViewcontroller
        self.rearViewcontroller = rearViewcontroller
        self.rearViewcontroller?.transitioningDelegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if rearViewcontroller != nil {
            menuPresentationInteractionController = MenuPresentationInteractionController(viewController: self, menu: rearViewcontroller!)
            rearViewcontroller?.menuAnimationController = self
        }
        
        if frontViewcontroller != nil {
            //add it as child
            addChildViewController(frontViewcontroller!)
            view.addSubview(frontViewcontroller!.view)
            frontViewcontroller?.didMove(toParentViewController: self)
            frontViewcontroller?.menuAnimationController = self
        }
    }

    public func showMenu() {
        rearViewcontroller?.transitioningDelegate = self
        present(rearViewcontroller!, animated: true)
    }
}

extension AnimatedCircularMenuController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        menuPresentationAnimationController.shouldDismiss = false
        return menuPresentationAnimationController
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        menuPresentationAnimationController.shouldDismiss = true
        return menuPresentationAnimationController
    }
    
    func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return menuPresentationInteractionController.animationInProgress ? menuPresentationInteractionController : nil
    }
}

extension UIViewController {
    struct Holder {
        static var _menuAnimationController: AnimatedCircularMenuController? = nil
    }
    
    weak var menuAnimationController: AnimatedCircularMenuController? {
        get{
            return Holder._menuAnimationController
        }set{
            Holder._menuAnimationController = newValue
        }
    }
}

