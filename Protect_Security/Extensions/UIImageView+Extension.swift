//
//  Image+Extension.swift
//  Protect_Security
//
//  Created by Harish Chandra Singh on 26/12/2018.
//  Copyright © 2018 Jatin Garg. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
    func setRoundImage() {
        self.layer.cornerRadius = self.frame.width/2.0
        self.layer.masksToBounds = true
    }
}

