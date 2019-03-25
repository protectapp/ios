//
//  CreatePasswdService.swift
//  Protect_Security
//
//  Created by Harish Chandra Singh on 31/12/2018.
//  Copyright © 2018 Jatin Garg. All rights reserved.
//

//#MARK: Password creation for Security person

import Foundation

class CreatePasswdService: NetworkRequest {
    
    private let password: String
    
    init(password: String) {
        
        self.password = password
    }
    
    typealias T = Usermodel
    
    var path: String {
        return APIConfig.createPass
    }
    var method: RequestType {
        return .post
    }
    var params: [String : Any] {
        return ["password": password]
    }
}
