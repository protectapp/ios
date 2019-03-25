//
//  LoginWithPasswordVC.swift
//  Protect_Security
//
//  Created by Jatin Garg on 18/12/18.
//  Copyright © 2018 Jatin Garg. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

class LoginWithPasswordVC: UIViewController {
    
    @IBOutlet weak var phoneNumberField: ProtectField!
    @IBOutlet weak var passwordField: ProtectField!
    @IBOutlet weak var phoneErrorLabel: UILabel!
    @IBOutlet weak var passwordErrorLabel: UILabel!
  
    private var errorLabels: [UILabel] {
        return [
            phoneErrorLabel,passwordErrorLabel
        ]
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureFields()
        errorLabels.forEach { $0.text = nil }
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(named: "backbround"),for: .default)
    }

    private func configureFields() {
        self.navigationItem.setHidesBackButton(true, animated:true)
        phoneNumberField.delegate = self
        passwordField.delegate = self
        phoneNumberField.keyboardType = .numberPad
        phoneNumberField.text = Constants.COUNTRY_CODE
    }
    
    @IBAction func loginTapped(_ sender: UIButton) {
        guard
            let phoneNumber = phoneNumberField.text,
            phoneNumber.trim() != Constants.COUNTRY_CODE,
            phoneNumber.trim().count > 0
            else {
                resetFields()
                resetErrorLabels()
                self.phoneNumberField.shouldIndicateError = true
                self.phoneErrorLabel.text = "Mobile number is required"
                return
        }
        guard
            let password = passwordField.text,
            password.trim().count > 0
            else {
                resetFields()
                resetErrorLabels()
                self.passwordField.shouldIndicateError = true
                self.passwordErrorLabel.text = "Password is required"
                return
        }
        
        if phoneNumberField.text!.trim().isValid(regex: .phone){
            let service = LoginService(contact: phoneNumber, password: password, deviceToken: UserPreferences.deviceToken)
            view.showIndicator()
            service.fire { (model, error) in
                self.view.hideIndicator()
                if error != nil {
                    self.passwordErrorLabel.text = error?.localizedDescription
                    self.phoneNumberField.shouldIndicateError = true
                    self.passwordField.shouldIndicateError = true
                } else {
                    UserPreferences.userDetails = model!
                    if let token = model?.token {
                        UserPreferences.userToken = token
                        if let shouldCretePass = model?.shouldCreatePassword {
                            if shouldCretePass {
                                self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
                                self.view.endEditing(true)
                                    self.navigationController?.pushViewController(CreatePasswordVC(), animated: true)
                            } else {
                                self.moveToDashboardVC()
                            }
                        }
                    } else {
                        System.showInfo(withMessage: "The server is not responding.", ofType: .error, onVC: self)
                    }
                }
            }
        } else {
            resetFields()
            resetErrorLabels()
            self.phoneNumberField.shouldIndicateError = true
            self.phoneErrorLabel.text = "Not a valid contact number."
        }
    }
    
   private func moveToDashboardVC() {
        let frontVC = DashboardVC()
        frontVC.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        let navigator = System.navigationController
        navigator.setViewControllers([frontVC], animated: true)
        let rootVC = AnimatedCircularMenuController(frontViewcontroller: navigator, rearViewcontroller: MenuVC())
        self.navigationController?.setViewControllers([rootVC], animated: true)
        rootVC.navigationController?.isNavigationBarHidden = true
    }
    
    @IBAction func forgotPasswordTapped(_ sender: UIButton) {
    
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.view.endEditing(true)
        let otpVC = OTPRequestVC()
        otpVC.isComingFromForgetPass = true
        navigationController?.pushViewController(otpVC, animated: true)
    }
    
    private func resetErrorLabels() {
        errorLabels.forEach( { $0.text = nil })
    }
    
    private func resetFields() {
        phoneNumberField.shouldIndicateError = false
        passwordField.shouldIndicateError = false
    }
}

extension LoginWithPasswordVC: ProtectFieldDelegate {
    func didTapRightActionButton(field: ProtectField) {
        if field == passwordField {
            let isSecure = field.isSecure
            field.rightImage = isSecure ? UIImage(named: "eye") : UIImage(named: "eye-off")
            field.isSecure = !field.isSecure
        }
    }
    
    private func fieldDidBeginEditing(field: ProtectField) {
        resetFields()
        resetErrorLabels()
        guard
            let text = field.text else {
                return
        }
        if text == Constants.COUNTRY_CODE {
            field.text = text + " "
        }
    }
    
    private func shouldChange(charactersInRange range: NSRange, replacementString string: String, field: ProtectField) -> Bool {
        if field == phoneNumberField {
            if let text = field.text {
                return !(text == "\(Constants.COUNTRY_CODE) " && System.isBackSpace(string))
            }
        }
        return true
    }
}

