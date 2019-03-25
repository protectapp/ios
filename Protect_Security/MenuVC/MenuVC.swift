//
//  MenuVC.swift
//  Protect_Security
//
//  Created by Jatin Garg on 19/12/18.
//  Copyright © 2018 Jatin Garg. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class MenuVC: UIViewController {
    
    @IBOutlet weak var closeImage: InteractiveImageview!
    @IBOutlet var menuItems: [InteractiveView]!
    
    @IBOutlet weak var lbluserName: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblContactNo: UILabel!
    @IBOutlet weak var imgUserPic: InteractiveImageview!
    
    @IBOutlet weak var menuTopContaint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        closeImage.delegate = self
        imgUserPic.delegate = self
        imgUserPic.isUserInteractionEnabled = true
        menuItems.forEach({$0.delegate = self})
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        //Showing the security person's details from local storage
        if let userDetails = UserPreferences.userDetails {
            if let userImageUrl = userDetails.profileImageURL {
                if let url = URL(string: userImageUrl) {
                    imgUserPic.sd_setImage(with: url, placeholderImage: UIImage(named: "default_user"))
                }
            }
            lbluserName.text = userDetails.name ?? ""
            lblContactNo.text = userDetails.contactNumber
            lblEmail.text = userDetails.email ?? ""
        }
    }
    
    @IBAction func closeTapped(_ sender: UIButton) {
        dismiss(animated: true)
    }
}

extension MenuVC: InteractiveViewDelegate {
    func viewTapped(_ sender: InteractiveView) {
        guard let frontVC = menuAnimationController?.frontViewcontroller as? UINavigationController else{
            return
        }
        var shouldPush = false
        var shouldPop = false
        var vcToPush: UIViewController?
        var isLogout = false
        
        switch sender.tag {
        case 0:
            //home
            shouldPop = true
            isLogout = false
            break
        case 1:
            //profile
            shouldPush = true
            isLogout = false
            vcToPush = ProfileVC()
            break
        case 2:
            //change password
            shouldPush = true
            isLogout = false
            vcToPush = ChangePasswordVC()
            break
        case 3:
            //about
            shouldPush = true
            isLogout = false
            vcToPush = AboutUsViewController()
            (vcToPush as? AboutUsViewController)?.contentType = "AboutUs"
            
            break
        case 4:
            //privacy
            shouldPush = true
            isLogout = false
            vcToPush = AboutUsViewController()
            (vcToPush as? AboutUsViewController)?.contentType = "privacy"
            
            break
        case 5:
            //logout
            isLogout = true
            let alertController = UIAlertController(title: InfoType.information.title, message: "Are you sure you want to logout?", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Yes", style: UIAlertActionStyle.default) {
                UIAlertAction in
                RequestHandler.shared.redirectToAuth()
                self.logOutApiCalling()
                return
            }
            let cancelAction = UIAlertAction(title: "No", style: UIAlertActionStyle.cancel) {
                UIAlertAction in
                isLogout = false
            }
            alertController.addAction(okAction)
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true, completion: nil)
            
            break
        default:
            break
        }
        if !isLogout {
            dismiss(animated: true) {
                if shouldPush {
                    frontVC.pushViewController(vcToPush!, animated: true)
                }
                if shouldPop {
                    _=frontVC.popToRootViewController(animated: true)
                }
            }
        }
    }
    //#MARK: Security user logout
    private func logOutApiCalling() {
        let service = UserLogoutService(deviceToken: UserPreferences.deviceToken ?? "")
        service.fire { (model, error) in
            try? FirAuth.signOut()
        }
    }
}
//#MARK: Close and Profile Image Tapped Action
extension MenuVC: InteractiveImageviewDelegate {
    func imageTapped(_ sender: InteractiveImageview) {
        if sender == closeImage {
            dismiss(animated: true)
        } else if sender == imgUserPic {
            guard let frontVC = menuAnimationController?.frontViewcontroller as? UINavigationController else{
                return
            }
            let vcToPush = ProfileVC()
            dismiss(animated: true) {
                frontVC.pushViewController(vcToPush, animated: true)
            }
        }
    }
}
