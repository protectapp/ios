//
//  UserLogoutService.swift
//  Protect_Security
//
//  Created by Harish Chandra Singh on 03/01/2019.
//  Copyright © 2019 Jatin Garg. All rights reserved.
//
//#MARK: Security Person logout

import Foundation

class UserLogoutService: NetworkRequest {
    
    public var deviceToken:String
    
    init(deviceToken : String) {
        self.deviceToken = deviceToken
    }
    
    typealias T = Usermodel
    
    var path: String {
        return (APIConfig.userLogout + deviceToken)
    }
    var method: RequestType {
        return .get
    }
    var params: [String : Any] {
        return [:]
    }
}
