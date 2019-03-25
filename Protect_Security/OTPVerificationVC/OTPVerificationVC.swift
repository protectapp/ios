//
//  OTPVerificationVC.swift
//  Protect_Security
//
//  Created by Jatin Garg on 18/12/18.
//  Copyright © 2018 Jatin Garg. All rights reserved.
//

import UIKit

class OTPVerificationVC: UIViewController {
    
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var otpField: OTPField!
    @IBOutlet weak var otpTimerLabel: UILabel!
    
    @IBOutlet weak var verifyButton: UIButton!
    @IBOutlet weak var resendView: UIView!
    @IBOutlet weak var lblDontReceiveCode: UILabel!
    @IBOutlet weak var lblDontGetWidthCongtraint: NSLayoutConstraint!
    
    @IBOutlet weak var infoStackView: UIStackView!
    @IBOutlet weak var btnResend: UIButton!
    
    var contactNo = ""
    var isVisiter = false
    var validity = Int()
    
    var count = 180
    var isComingFromForgetPass = false
    var timer:Timer?

    override func viewDidLoad() {
        super.viewDidLoad()
    
        resendView.isHidden = true
        messageLabel.text =  "Enter the OTP sent to \(contactNo)"
        count = validity
        otpTimerLabel.text =  "\(count/60):\(count%60)"
        startTimer()
  
        #if Protect_Security
            isVisiter = false
        #elseif Protect_User
            isVisiter = true
        #endif
    }
    
    private func startTimer(){
        if timer == nil {
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector:  #selector(update), userInfo: nil, repeats:true)
        }
    }
    private func stopTimerTest() {
        if timer != nil {
            timer!.invalidate()
            timer = nil
        }
    }
    
    @objc func update() {
        if(count > 0) {
            infoStackView.isHidden = false
            count = count - 1
            if count%60 > 9 {
                otpTimerLabel.text = "\(count/60):\(count%60)"
            } else {
                otpTimerLabel.text = "\(count/60):0\(count%10)"
            }
        } else {
              resendView.isHidden = false
              infoStackView.isHidden = true
              stopTimerTest()
        }
    }
    
    @IBAction func btnResendOtpTapped(_ sender: Any) {
        resetState()
        let service = RequestOtpService(contactNumber: contactNo, isForgottenPass: isComingFromForgetPass)
        view.showIndicator()
        service.fire { (model, error) in
            
            self.view.hideIndicator()
            
            if error != nil {
                System.showInfo(withMessage: error!.localizedDescription, ofType: .error, onVC: self)
            } else {
                System.showInfo(withMessage: "OTP sent on your registered mobile number.", ofType: .information, onVC: self)
                let validity = model?.validity ?? ""
                self.count = Int(validity) ?? 0
                self.startTimer()
                self.otpTimerLabel.text =  "\(self.count/60):\(self.count%60)"
            }
        }
    }

    @IBAction func verifyButtonTapped(_ sender: UIButton) {
        if otpField.otpText!.count > 0 {
            verifyOtpCalling()
        } else {
            otpField.shake()
        }
    }
    
    //#MARK: Otp Verification Api Call
    private func verifyOtpCalling() {
        resetStateForVerifyOtp()

        let service = VerifyOtpService(contactNumber: contactNo, isVisiter: isVisiter, otp: otpField.otpText!)
        view.showIndicator()
        service.fire { (model, error) in
            
            self.view.hideIndicator()
            
            if error != nil {
                System.showInfo(withMessage: error!.localizedDescription, ofType: .error, onVC: self)
                self.lblDontReceiveCode.text = "Wrong Code"
                self.lblDontGetWidthCongtraint.constant = 180
                self.view.layoutIfNeeded()
            } else {
                if model?.isOTPValid ?? false {
                    self.lblDontGetWidthCongtraint.constant = 235
                    self.view.layoutIfNeeded()
                    UserPreferences.userToken = model?.accesstoken ?? ""
                    
                    #if Protect_Security
                    self.moveToResetPassword()
                    #elseif Protect_User
                    self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
                    self.view.endEditing(true)
                    self.navigationController?.pushViewController(DashboardVC(), animated: true)
                    #endif
                } else {
                    self.lblDontReceiveCode.text = "Wrong Code"
                    self.lblDontGetWidthCongtraint.constant = 180
                    self.view.layoutIfNeeded()
                }
            }
        }
    }
    private func moveToResetPassword() {
        #if Protect_Security
        let resetPassVc = CreatePasswordVC()
        resetPassVc.isResetPass = true
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.view.endEditing(true)
        self.navigationController?.pushViewController(resetPassVc, animated: true)
        #endif
    }
    
    //#MARK: Reset previos state
    private func resetStateForVerifyOtp() {
        self.count = 0
        self.otpTimerLabel.text = "0:00"
        self.infoStackView.isHidden = true
    }
    
    func resetState() {
        self.resendView.isHidden = true
        self.infoStackView.isHidden = false
        self.lblDontReceiveCode.text = "Didn't received code?"
        self.lblDontGetWidthCongtraint.constant = 235
        view.layoutIfNeeded()
    }
}

extension OTPVerificationVC: OTPBoxDelegate {
    func didTapBackspace(in box: OTPBox) {
    }
    
    func didEnter(digit: Int, in box: OTPBox) {
    }
}
