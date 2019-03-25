//
//  NotifcnTokenRegisterService.swift
//  Protect_Security
//
//  Created by Harish Chandra Singh on 03/01/2019.
//  Copyright © 2019 Jatin Garg. All rights reserved.
//
//#MARK: Updating Firebase refresh token as Psuh notification token

import Foundation

class NotifcnTokenRegisterService: NetworkRequest {
    
    private let deviceToken: String
 
    init(deviceToken: String) {
        self.deviceToken = deviceToken
    }
    
    typealias T = Usermodel
    
    var path: String {
        return APIConfig.notifcnTokenRegister
    }
    var method: RequestType {
        return .post
    }
    var params: [String : Any] {
        return ["deviceToken": deviceToken]
    }
}
