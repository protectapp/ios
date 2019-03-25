//
//  RequestOtpService.swift
//  Protect_Security
//
//  Created by Harish Chandra Singh on 31/12/2018.
//  Copyright © 2018 Jatin Garg. All rights reserved.
//
//#MARK: Request OTP

import Foundation

class RequestOtpService: NetworkRequest {
    
    private let contactNumber: String
    private let isForgottenPass: Bool
    private var isVisitor = false
    
    init(contactNumber: String, isForgottenPass : Bool) {
        
        self.contactNumber = contactNumber
        self.isForgottenPass = isForgottenPass
    }
    
    typealias T = GetOtpreqModel
    
    var path: String {
        return APIConfig.getOTP
    }
    var method: RequestType {
        return .post
    }
    var params: [String : Any] {
       
        #if Protect_Security
        isVisitor = false
        #elseif Protect_User
        isVisitor = true
        #endif
        
        return ["contactNumber": contactNumber, "hasForgottenPw" : isForgottenPass, "isVisitor" : isVisitor, "deviceToken" : UserPreferences.deviceToken as Any ]
    }
}
