//
//  LoginService.swift
//  Protect_Security
//
//  Created by Jatin Garg on 24/12/18.
//  Copyright © 2018 Jatin Garg. All rights reserved.
//
//# MARK: This is authenticating Security Persons 
import Foundation

class LoginService: NetworkRequest {
    
    private let contactNumber: String
    private let password: String
    private var deviceToken: String?
    
    init(contact: String, password: String, deviceToken: String?) {
        contactNumber = contact
        self.password = password
        self.deviceToken = deviceToken
    }
    
    typealias T = Usermodel
    
    var path: String {
        return APIConfig.login
    }
    var method: RequestType {
        return .post
    }
    var params: [String : Any] {
        var inDict = ["contactNumber": contactNumber,
                      "password" : password]
        
        if let token = deviceToken {
            inDict["deviceToken"] = token
        }
        return inDict
    }
}
