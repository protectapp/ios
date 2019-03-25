//
//  ForgotPWDVC.swift
//  Protect_Security
//
//  Created by Jatin Garg on 18/12/18.
//  Copyright © 2018 Jatin Garg. All rights reserved.
//

import UIKit

class OTPRequestVC: UIViewController {
    
    @IBOutlet weak var phoneNumberField: ProtectField!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
  
    public var isComingFromForgetPass = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        phoneNumberField.delegate = self
        titleLabel.text = Strings.OTPRequestTitle
        messageLabel.attributedText = Strings.OTPRequestMessage
        phoneNumberField.text = Constants.COUNTRY_CODE
        phoneNumberField.keyboardType = .numberPad
      
        navigationController?.navigationBar.setBackgroundImage(UIImage(named: "backbround"),for: .default)
    }

    @IBAction func btnGetOtpTapped(_ sender: Any) {
        if !(phoneNumberField.text?.isEmpty)! {
            if (phoneNumberField.text?.count)! > 12 {
                getOtpApiCalling()
            } else {
                 phoneNumberField.shake()
            }
        }
    }
    
    func getOtpApiCalling() {
        
        let service = RequestOtpService(contactNumber: phoneNumberField.text!, isForgottenPass: isComingFromForgetPass)
        view.showIndicator()
        service.fire { (model, error) in
            self.view.hideIndicator()
            
            if error != nil {
                System.showInfo(withMessage: error!.localizedDescription, ofType: .error, onVC: self)
            } else {
                let optpVerfVC = OTPVerificationVC()
                self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
                self.view.endEditing(true)
                optpVerfVC.contactNo = self.phoneNumberField.text!
                optpVerfVC.isComingFromForgetPass = self.isComingFromForgetPass
                
                let validity = model?.validity ?? ""
                optpVerfVC.validity = Int(validity) ?? 0
                self.navigationController?.pushViewController(optpVerfVC, animated: true)
            }
        }
    }
}

extension OTPRequestVC: ProtectFieldDelegate {
    func shouldChange(charactersInRange range: NSRange, replacementString string: String, field: ProtectField) -> Bool {
        if field == phoneNumberField {
            if let text = field.text {
                return !(text == "\(Constants.COUNTRY_CODE) " && System.isBackSpace(string))
            }
        }
        return true
    }
    
    func fieldDidBeginEditing(field: ProtectField) {
        guard
            let text = field.text else {
            return
        }
        if text == Constants.COUNTRY_CODE {
            field.text = text + " "
        }
    }
}

