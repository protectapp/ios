//
//  InteractiveView.swift
//  Protect_Security
//
//  Created by Jatin Garg on 19/12/18.
//  Copyright © 2018 Jatin Garg. All rights reserved.
//

import UIKit

class InteractiveView: UIView{
    public weak var delegate: InteractiveViewDelegate?
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        UIView.animate(withDuration: 0.15, delay: 0, options: [.allowUserInteraction, .curveEaseInOut], animations: {
            self.alpha = 0.5
            self.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        }, completion: nil)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        UIView.animate(withDuration: 0.3, delay: 0, options: [.allowUserInteraction, .curveEaseInOut], animations: {
            self.alpha = 1
            self.transform = .identity
        }){ _ in
            self.delegate?.viewTapped(self)
            super.touchesEnded(touches, with: event)
        }
        
    }
}
