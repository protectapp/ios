//
//  IndicatorView.swift
//  Protect_Security
//
//  Created by Jatin Garg on 26/12/18.
//  Copyright © 2018 Jatin Garg. All rights reserved.
//

import UIKit

class IndicatorView: View {
    private static var instances: [UIView:IndicatorView] = [:]
    
    private var spinner: UIActivityIndicatorView = {
        let i = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
        i.startAnimating()
        i.hidesWhenStopped = true
        return i
    }()
    
    override func setup() {
        super.setup()
        
        addSubview(spinner)
        spinner.setCenter(withRespectTo: self, axis: .horizontal)
        spinner.setCenter(withRespectTo: self, axis: .vertical)
        backgroundColor = UIColor.black.withAlphaComponent(0.4)
    }
    
    public static func showOver(_ view: UIView) {
        guard instances[view] == nil else {
            return
        }
        let newinstance = IndicatorView()
        newinstance.alpha = 0
        instances[view] = newinstance
        view.addSubview(newinstance)
        newinstance.anchor(toView: view, myHorizontalEdge: .left, viewHorizontalEdge: .left, shouldUseSafeAreaHorizontally: false, horizontalOffset: 0, myVerticalEdge: .top, viewVerticalEdge: .top, shouldUseSafeAreaVertically: false, verticalOffset: 0)
        newinstance.anchor(toView: view, myHorizontalEdge: .right, viewHorizontalEdge: .right, shouldUseSafeAreaHorizontally: false, horizontalOffset: 0, myVerticalEdge: .bottom, viewVerticalEdge: .bottom, shouldUseSafeAreaVertically: false, verticalOffset: 0)
        UIView.animate(withDuration: 0.3) {
            newinstance.alpha = 1
        }
    }
    
    public static func hideFrom(_ view: UIView) {
        guard let previousInstance = instances[view] else {
            return
        }
        
        UIView.animate(withDuration: 0.3,animations: {
            previousInstance.alpha = 0
        }){ _ in
            self.instances[view] = nil
            previousInstance.removeFromSuperview()
        }
    }
}
