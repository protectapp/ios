//
//  OTPBoxDelegate.swift
//  Protect_Security
//
//  Created by Jatin Garg on 19/12/18.
//  Copyright © 2018 Jatin Garg. All rights reserved.
//

import Foundation

protocol OTPBoxDelegate: class {
    func didEnter(digit: Int, in box: OTPBox)
    func didTapBackspace(in box: OTPBox)
}
