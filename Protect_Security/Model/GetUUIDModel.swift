//
//  GetUUIDModel.swift
//  Protect_Security
//
//  Created by Harish Chandra Singh on 04/01/2019.
//  Copyright © 2019 Jatin Garg. All rights reserved.
//

import Foundation

struct GetUUIDModel: Codable {
    
    public var beaconUUID:String
    
    private enum CodingKeys: String, CodingKey {
        case beaconUUID = "UUID"
    }
}
