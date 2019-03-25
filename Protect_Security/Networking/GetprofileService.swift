//
//  GetprofileService.swift
//  Protect_Security
//
//  Created by Harish Chandra Singh on 26/12/2018.
//  Copyright © 2018 Jatin Garg. All rights reserved.
//
//# MARK: Get the Security profile details

import Foundation

class GetprofileService: NetworkRequest {
    
    typealias T = Usermodel
    
    var path: String {
        
        return APIConfig.getUserProfile
    }
    var method: RequestType {
        return .get
    }
    var params: [String : Any] {
        return [:]
    }
}
