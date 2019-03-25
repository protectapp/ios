//
//  VerifyOtpModel.swift
//  Protect_Security
//
//  Created by Harish Chandra Singh on 02/01/2019.
//  Copyright © 2019 Jatin Garg. All rights reserved.
//

import Foundation

struct VerifyOtpModel : Codable {
    
    public var isOTPValid: Bool
    public var accesstoken : String
    
    private enum CodingKeys: String, CodingKey {
        case isOTPValid
        case accesstoken
    }
}
