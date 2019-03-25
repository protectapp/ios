//
//  OTPBox.swift
//  Protect_Security
//
//  Created by Jatin Garg on 18/12/18.
//  Copyright © 2018 Jatin Garg. All rights reserved.
//

import UIKit
extension OTPBox: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let conditionForFalse = !System.isBackSpace(string) && ((textField.text != nil && textField.text!.trim().count != 0 ) || (string.trim().count != 1) || (Int(string) == nil))
        
        if conditionForFalse {
            return false
        }
        return true
    }
}

class OTPBox: View {
    public lazy var textfield: OTPTextfield = {
        let t = OTPTextfield()
        t.keyboardType = .numberPad
        t.font = Font.font(ofSize: 20, andFace: .bold)
        t.textAlignment = .center
        t.textColor = Color.otpTextColor
        t.setContentHuggingPriority(.defaultLow, for: .vertical)
        t.setContentHuggingPriority(.defaultLow, for: .horizontal)
        t.delegate = self
        t.addTarget(self, action: #selector(boxChanged), for: .editingChanged)
        return t
    }()
    
    public var text: String? {
        get {
            return textfield.text
        }set{
            textfield.text = newValue
        }
    }
    
    public weak var delegate: OTPBoxDelegate?
    
    override func setup() {
        super.setup()
        addSubview(textfield)
        textfield.setWidth(equalToView: self)
        textfield.setHeight(equalToView: self)
        textfield.setCenter(withRespectTo: self, axis: .horizontal)
        textfield.setCenter(withRespectTo: self, axis: .vertical)
        
        //extras
        layer.masksToBounds = true
        layer.cornerRadius = 3
        layer.borderWidth = 1
        layer.borderColor = Color.textfieldBorderColor.cgColor
        
        NotificationCenter.default.addObserver(self, selector: #selector(backSpaceTapped), name: Notification.Name("backSpaceNotification"), object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: Notification.Name("backSpaceNotification"), object: nil)
    }
    
    @objc func boxChanged(_ sender: UITextField) {
        if let currentText = sender.text?.trim(){
            if currentText.count == 1, let digit = Int(currentText)  {
                delegate?.didEnter(digit: digit, in: self)
            }
        }
        
    }
    
    @objc func backSpaceTapped(_ notification: Notification) {
        guard
            let field = notification.object as? OTPTextfield,
            field == textfield
        else {
            return
        }
        delegate?.didTapBackspace(in: self)
    }
    
    override func becomeFirstResponder() -> Bool {
        _=textfield.becomeFirstResponder()
        return super.becomeFirstResponder()
    }
}
