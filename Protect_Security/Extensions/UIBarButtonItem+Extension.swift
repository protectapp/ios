//
//  UIBarButtonItem+Extension.swift
//  Protect_Security
//
//  Created by Harish Chandra Singh on 21/01/2019.
//  Copyright © 2019 Jatin Garg. All rights reserved.
//

import Foundation
import UIKit

extension UIBarButtonItem {
    static func setCustomBarButton(image: UIImage, title: String, target: Any, action: Selector) -> UIBarButtonItem {
        let button = UIButton()
        button.setImage(image, for: .normal)
        button.addTarget(target, action: action, for: .touchUpInside)
        button.setTitle(title, for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.backgroundColor = UIColor.red
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        button.titleLabel?.layer.cornerRadius = 7
        button.titleLabel?.layer.masksToBounds = true
        button.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 10, 0)
        button.sizeToFit()
        return UIBarButtonItem(customView: button)
    }
    
    func setTitle(_ title: String) {
        guard let button = customView as? UIButton else{
            return
        }
        button.setTitle(title, for: .normal)
    }
}
