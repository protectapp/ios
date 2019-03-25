//
//  AboutUsViewController.swift
//  Protect_Security
//
//  Created by Harish Chandra Singh on 27/12/2018.
//  Copyright © 2018 Jatin Garg. All rights reserved.
//

import UIKit

class AboutUsViewController: UIViewController {

    @IBOutlet weak var aboutusWebView: UIWebView!
   
    var contentType = ""
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        aboutusWebView.clipsToBounds = false
        aboutusWebView.backgroundColor = .white

        if contentType == "AboutUs" {
            navigationItem.title = "About ProtectApp™"
        } else {
            navigationItem.title = "Privacy Policy"
        }
        getCMSContentApiCalling()
    }
    //#MARK: Get the static Contents
    func getCMSContentApiCalling() {
        
        let service = GetCMSContentService(contentType: contentType == "AboutUs" ? .aboutUs : .privacyPolicy)
        view.showIndicator()
        service.fire { (model, error) in
            
            self.view.hideIndicator()
            
            if error != nil {
                
            } else {
                if let aboutUsdata = model?.data  {
                    self.aboutusWebView.loadHTMLString(aboutUsdata, baseURL: nil)
                }
            }
        }
    }
}
