//
//  GetOtpreqModel.swift
//  Protect_Security
//
//  Created by Harish Chandra Singh on 02/01/2019.
//  Copyright © 2019 Jatin Garg. All rights reserved.
//

import Foundation

struct GetOtpreqModel: Decodable, Encodable {
    
    public var otp: Int
    public var validity : String
    
    private enum CodingKeys: String, CodingKey {
        case otp = "OTP"
        case validity
    }
}
