//
//  CreatePasswordVC.swift
//  Protect_Security
//
//  Created by Jatin Garg on 20/12/2018.
//  Copyright © 2018 Jatin Garg. All rights reserved.
//

import UIKit

class CreatePasswordVC: UIViewController {
    
    @IBOutlet weak var tfNewPassword: ProtectField!
    @IBOutlet weak var tfConfirmPassword: ProtectField!
    @IBOutlet weak var lblNewPassError: UILabel!
    @IBOutlet weak var lblConfPassError: UILabel!
    
    @IBOutlet weak var btnCreatePass: UIButton!
    @IBOutlet weak var lblCreatePass: UILabel!
    @IBOutlet weak var imgLogo: UIImageView!
    
    @IBOutlet weak var logoHeightConst: NSLayoutConstraint!
    @IBOutlet weak var logoWidthConst: NSLayoutConstraint!
    @IBOutlet weak var imgTopcontaint: NSLayoutConstraint!
    
    var isResetPass = false
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        resizeLogoIconFor5S()
        intialSetUps()
    }
    
    func intialSetUps() {
        lblNewPassError.text = ""
        lblConfPassError.text = ""
        tfNewPassword.delegate = self
        tfConfirmPassword.delegate = self
        
        if isResetPass {
            lblCreatePass.text = "Reset Password"
            btnCreatePass.setTitle("Reset Password", for: .normal)
        }
    }
    
    @IBAction func btNCreaTePaaaTapped(_ sender: Any) {
        if !(tfNewPassword.text?.isEmpty)! && !(tfConfirmPassword.text?.isEmpty)! {
            if tfNewPassword.text! == tfConfirmPassword.text! {
                if (tfNewPassword.text!.isValidPassword()) {
                    createPasswordApiCalling()
                    lblNewPassError.text = ""
                    lblConfPassError.text = ""
                } else {
                    lblNewPassError.text = "Not a valid password format."
                    lblConfPassError.text = ""
                }
            } else {
                lblNewPassError.text = ""
                lblConfPassError.text = "Passwords don't match."
            }
        } else {
            if (tfNewPassword.text?.isEmpty)! && (tfConfirmPassword.text?.isEmpty)!{
                lblNewPassError.text = "This field is required."
                lblConfPassError.text =  "This field is required."
            } else if (tfNewPassword.text?.isEmpty)! {
                lblNewPassError.text = "This field is required."
                lblConfPassError.text =  ""
            } else {
                lblNewPassError.text = ""
                lblConfPassError.text =  "This field is required."
            }
        }
    }
    
    private func resizeLogoIconFor5S(){
        if UIDevice().userInterfaceIdiom == .phone {
            switch UIScreen.main.bounds.size.height{
            case 480,568:
                print("iPhone 4S", "iPhone 5","iPhone SE")
                logoHeightConst.constant = 70
                logoWidthConst.constant = 250
                imgTopcontaint.constant = 8
                imgLogo.image = UIImage(named: "dashLogo_Small")
                view.layoutIfNeeded()
            default:
                print("other models")
            }
        }
    }
    
    func createPasswordApiCalling() {
        let service = CreatePasswdService(password: tfNewPassword.text!)
        view.showIndicator()
        service.fire { (model, error) in
            self.view.hideIndicator()
            if error != nil {
                System.showInfo(withMessage: error!.localizedDescription, ofType: .error, onVC: self)
            } else {
                if model?.token == nil && self.isResetPass {
                    UserPreferences.userDetails = model!
                    UserPreferences.userDetails?.token = UserPreferences.userToken
                }
                self.moveToDashboradVC()
            }
        }
    }
    
    private func moveToDashboradVC() {
        let frontVC = DashboardVC()
        frontVC.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        let navigator = System.navigationController
        navigator.setViewControllers([frontVC], animated: true)
        let rootVC = AnimatedCircularMenuController(frontViewcontroller: navigator, rearViewcontroller: MenuVC())
        self.navigationController?.setViewControllers([rootVC], animated: true)
        rootVC.navigationController?.isNavigationBarHidden = true
    }
}

extension CreatePasswordVC: ProtectFieldDelegate {
    func didTapRightActionButton(field: ProtectField) {
        let isSecure = field.isSecure
        field.rightImage = isSecure ? UIImage(named: "eye") : UIImage(named: "eye-off")
        field.isSecure = !field.isSecure
    }
}
