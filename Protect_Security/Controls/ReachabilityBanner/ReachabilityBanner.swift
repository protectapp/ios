//
//  ReachabilityBanner.swift
//  Protect_Security
//
//  Created by Jatin Garg on 21/01/19.
//  Copyright © 2019 Jatin Garg. All rights reserved.
//

import UIKit

class ReachabilityBanner: View {
    public var isNetworkReachable: Bool = false {
        didSet{
            switchUI()
        }
    }
    private weak var currentViewController: UIViewController!
    private let networkReachableMessage: String = "You are online."
    private let networkUnreachableMessage: String = "You are offline."
    
    private var messageLabel: UILabel = {
        let l = UILabel()
        l.numberOfLines = 2
        l.translatesAutoresizingMaskIntoConstraints = false
        l.textAlignment = .center
        l.font = UIFont.systemFont(ofSize: 12)
        l.textColor = .white
        return l
    }()
    
    private func switchUI() {
        switch isNetworkReachable {
        case true:
            messageLabel.text = networkReachableMessage
            backgroundColor = Color.networkAvailableColor
            break
        case false:
            messageLabel.text = networkUnreachableMessage
            backgroundColor = Color.newtworkUnavailableColor
            break
        }
    }
    
    override func setup() {
        addSubview(messageLabel)
        
        messageLabel.topAnchor.constraint(equalTo: topAnchor, constant: 4).isActive = true
        messageLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4).isActive = true
        messageLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 8).isActive = true
        messageLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -8).isActive = true
        
        //configure shadow
        layer.shadowOpacity = 0.7
        layer.shadowRadius = 3
        layer.shadowOffset = CGSize(width: 0, height: 1)
        layer.masksToBounds = false
    }
    
    public func addOver(_ viewController: UIViewController) {
        guard let view = viewController.view else { return }
        let existingBanner = view.subviews.filter({
            ($0 as? ReachabilityBanner != nil)
        }).first as? ReachabilityBanner
        
        if existingBanner == nil && isNetworkReachable {
            return
        }
        if existingBanner != nil && existingBanner!.isNetworkReachable == isNetworkReachable {
            animate({
                self.alpha = 1
            })
            return
        }
        
        if existingBanner != nil && existingBanner!.isNetworkReachable != isNetworkReachable && viewController == currentViewController{
            existingBanner?.isNetworkReachable = !existingBanner!.isNetworkReachable
            return
        }
        
        
        translatesAutoresizingMaskIntoConstraints = false
        currentViewController = viewController
        view.addSubview(self)
        if #available(iOS 11.0, *) {
            topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        } else {
            topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        }
        
        leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
        alpha = 0
        
        animate({
            self.alpha = 1
        })
        
        
    }
    
    public func removeFromCurrentView() {
        animate({
            self.alpha = 0
        }) {
            //self.removeFromSuperview()
        }
    }
    
    private func animate(_ animationBlock: @escaping ()->(), _ completion: (()->())? = nil) {
        UIView.animate(withDuration: 0.4, animations: {
            animationBlock()
        }) { _ in
            completion?()
        }
    }
}
