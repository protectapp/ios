//
//  ChangePasswordVC.swift
//  Protect_Security
//
//  Created by Jatin Garg on 20/12/2018.
//  Copyright © 2018 Jatin Garg. All rights reserved.
//

import UIKit

class ChangePasswordVC: UIViewController {
    
    @IBOutlet weak var oldPasswordField: ProtectField!
    @IBOutlet weak var confirmPasswordField: ProtectField!
    @IBOutlet weak var newPasswordField: ProtectField!
    
    var isAllFilled = false
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        navigationItem.title = "Change Password"
        [oldPasswordField, newPasswordField, confirmPasswordField].forEach {
            $0?.delegate = self
        }
    }
    
    @IBAction func btnSaveTtaped(_ sender: Any) {
        if !(oldPasswordField.text?.isEmpty)! && !(newPasswordField.text?.isEmpty)!{
            if newPasswordField.text == confirmPasswordField.text {
                  isAllFilled = true
            } else {
                 System.showInfo(withMessage: "New password and confirm password should be same", ofType: .error, onVC: self)
            }
        } else {
            isAllFilled = false
            
            if (oldPasswordField.text?.isEmpty)! {
                System.showInfo(withMessage: "Old password is required", ofType: .error, onVC: self)
            } else {
                System.showInfo(withMessage: "New password is required", ofType: .error, onVC: self)
            }
        }
        if isAllFilled {
            if !(newPasswordField.text?.isValidPassword())! {
                 System.showInfo(withMessage: "Password should be min. 8 characters and include at least one number.", ofType: .error, onVC: self)
            } else {
                if oldPasswordField.text!.trim() != newPasswordField.text?.trim(){
                   changePasswordApiCalling()
                } else {
                    System.showInfo(withMessage: "New password can't be same as old password.Try new password", ofType: .error, onVC: self)
                }
            }
        }
    }
    
    //#MARK: Change Passord Api Call
    private func changePasswordApiCalling() {
        let service = ChangePassReqService(oldPassword: oldPasswordField.text!, newPassord: confirmPasswordField.text!)
        view.showIndicator()
        service.fire { (model, error) in
            self.view.hideIndicator()
            if error != nil {
                System.showInfo(withMessage: error!.localizedDescription, ofType: .error, onVC: self)
            } else {
                let toast = iToast(text: "Password changed successfully.")
                toast.show()
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
}

//#MARK: Show/hide passowrd
extension ChangePasswordVC: ProtectFieldDelegate {
    private func didTapRightActionButton(field: ProtectField) {
        let isSecure = field.isSecure
        field.rightImage = isSecure ? UIImage(named: "eye") : UIImage(named: "eye-off")
        field.isSecure = !field.isSecure
    }
}
