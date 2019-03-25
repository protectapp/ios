//
//  UpdateUserProfileService.swift
//  Protect_Security
//
//  Created by Harish Chandra Singh on 26/12/2018.
//  Copyright © 2018 Jatin Garg. All rights reserved.
//

//# MARK: Update Profine

import Foundation

class UpdateUserProfileService: NetworkRequest {
    
    private let name: String
    private let profileImage: String

    init(name: String, profileImage: String) {
        self.name = name
        self.profileImage = profileImage
    }
    
    typealias T = Usermodel
    
    var path: String {
        return APIConfig.updateprofile
    }
    var method: RequestType {
        return .post
    }
    var params: [String : Any] {
        return ["name": name, "profileImage" : profileImage]
    }
}
