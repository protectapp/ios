//
//  VerifyOtpService.swift
//  Protect_Security
//
//  Created by Harish Chandra Singh on 31/12/2018.
//  Copyright © 2018 Jatin Garg. All rights reserved.
//
//#MARK: OTP verification 

import Foundation

class VerifyOtpService: NetworkRequest {
    
    private let contactNumber: String
    private let isVisiter: Bool
    private let otp: String
    
    init(contactNumber: String, isVisiter : Bool, otp: String) {
        
        self.contactNumber = contactNumber
        self.isVisiter = isVisiter
        self.otp = otp
    }
    
    typealias T = VerifyOtpModel
    
    var path: String {
        return APIConfig.verifyOtp
    }
    var method: RequestType {
        return .post
    }
    var params: [String : Any] {
        return ["contactNumber": contactNumber,"OTP": otp, "isVisitor" : isVisiter, "deviceToken": (UserPreferences.deviceToken ?? "")]
    }
}
