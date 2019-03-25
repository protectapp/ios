//
//  OTPTextfield.swift
//  Protect_Security
//
//  Created by Jatin Garg on 19/12/18.
//  Copyright © 2018 Jatin Garg. All rights reserved.
//

import UIKit

class OTPTextfield: UITextField {
    override func deleteBackward() {
        super.deleteBackward()
        NotificationCenter.default.post(name: Notification.Name("backSpaceNotification"), object: self)
    }
}
