//
//  System.swift
//  Protect_Security
//
//  Created by Jatin Garg on 18/12/18.
//  Copyright © 2018 Jatin Garg. All rights reserved.
//

import UIKit

enum InfoType{
    case error, information
    
    public var title: String {
        return "ProtectApp™"
    }
}

class System {
    public static func isBackSpace(_ string: String) -> Bool {
        let char = string.cString(using: .utf8)
        let isBackSpace = strcmp(char, "\\b")
        return isBackSpace == -92
    }
    
    #if Protect_Security
    public static func constructSecurityRoot() -> UIViewController{
        if let _ = UserPreferences.userToken {
            let frontVC = DashboardVC()
            frontVC.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
            let navigator = navigationController
            navigator.setViewControllers([frontVC], animated: true)
            let rootVC = AnimatedCircularMenuController(frontViewcontroller: navigator, rearViewcontroller: MenuVC())
            return rootVC
            
        } else {
            let rootVC = LoginWithPasswordVC()
            rootVC.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
            let navigator = navigationController
            navigator.setViewControllers([rootVC], animated: true)
            return navigator
        }
    }
    #endif
    
    public static func constructUserRoot() -> UIViewController{
        var rootVC: UIViewController!
        if let _ = UserPreferences.userToken {
            rootVC = DashboardVC()
        }else{
            rootVC = OTPRequestVC()
        }
        rootVC.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        let navigator = navigationController
        navigator.setViewControllers([rootVC], animated: true)
        return navigator
    }
    
    public static func getPresentedViewController() -> UIViewController?{
        if let navigationController = getNavigationController() {
            
            return navigationController.visibleViewController
        }
        
        // Otherwise, we must get the root UIViewController and iterate through presented views
        if let rootController = UIApplication.shared.keyWindow?.rootViewController {
            
            var currentController: UIViewController! = rootController
            
            // Each ViewController keeps track of the view it has presented, so we
            // can move from the head to the tail, which will always be the current view
            while( currentController.presentedViewController != nil ) {
                
                currentController = currentController.presentedViewController
            }
            return currentController
        }
        return nil
    }
    
    #if Protect_Security
    public static var currentViewController: UIViewController? {
        guard
            let menuController = getPresentedViewController() as? AnimatedCircularMenuController,
            let navController = menuController.frontViewcontroller as? UINavigationController
            else{
                return nil
        }
        return navController.viewControllers.last
    }
    #endif
    
    public static func getNavigationController() -> UINavigationController? {
        if let navigationController = UIApplication.shared.keyWindow?.rootViewController  {
            return navigationController as? UINavigationController
        }
        return nil
    }
    
    public static var appName: String? {
        return "ProtectApp™"
    }
    
    static func getDate(from string: String, usingformat format: String) -> Date?{
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.date(from: string)
    }
    
    static func getString(fromDate date: Date?, usingFormat format: String) -> String? {
        guard let date = date else {
            return nil
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: date)
    }
    
    public static func getDocumentID(userID1: Int, userID2: Int) -> Int {
        return (Int(pow(Double(2), Double(15))) * userID1) + userID2
    }
    
    public static func showInfo(withMessage message: String, ofType infoType: InfoType, onVC vc: UIViewController) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: infoType.title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            vc.present(alert, animated: true)
        }
    }
   public static func dialNumber(number : String){
        if let url = URL(string: "tel://\(number)"),
            UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url, options: [:], completionHandler:nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        } else {
            // add error message here
        }
    }
}

extension System {
     static var navigationController: UINavigationController {
        let nav = UINavigationController()
        nav.navigationBar.shadowImage = UIImage()
        let backBtnImage = UIImage(named: "arrow-up")
        nav.navigationBar.backIndicatorImage = backBtnImage
        nav.navigationBar.tintColor = Color.navigationTintColor
        nav.navigationBar.backIndicatorTransitionMaskImage = backBtnImage
        nav.navigationBar.isTranslucent = false
        return nav
    }
}
