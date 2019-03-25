//
//  ChangePassReqService.swift
//  Protect_Security
//
//  Created by Harish Chandra Singh on 26/12/2018.
//  Copyright © 2018 Jatin Garg. All rights reserved.
//
//# MARK: Security persons can change their password. 

import Foundation

class ChangePassReqService: NetworkRequest {
    
    private let oldPassword: String
    private let newPassord: String

    init(oldPassword: String, newPassord: String) {
        
        self.oldPassword = oldPassword
        self.newPassord = newPassord
    }
    
    typealias T = Usermodel
    
    var path: String {
        return APIConfig.changePass
    }
    var method: RequestType {
        return .post
    }
    var params: [String : Any] {
        return ["oldPassword": oldPassword, "newPassword" : newPassord ]
    }
}
