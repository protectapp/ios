//
//  ProtectFieldDelegate.swift
//  Protect_Security
//
//  Created by Jatin Garg on 18/12/18.
//  Copyright © 2018 Jatin Garg. All rights reserved.
//

import Foundation


@objc protocol ProtectFieldDelegate: class {
    @objc optional func didTapRightActionButton(field: ProtectField)
    @objc optional func fieldDidBeginEditing(field: ProtectField)
    @objc optional func fieldDidEndEditing(field: ProtectField)
    @objc optional func didTapBackspace(field: ProtectField)
    @objc optional func shouldChange(charactersInRange range: NSRange, replacementString string: String, field: ProtectField) -> Bool
}
