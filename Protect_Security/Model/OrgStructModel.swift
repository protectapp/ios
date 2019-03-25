//
//  OrgStructModel.swift
//  Protect_Security
//
//  Created by Jatin Garg on 07/01/19.
//  Copyright © 2019 Jatin Garg. All rights reserved.
//

import Foundation

struct OrganizationStructure: Decodable {
    let organizationName: String
    let premiseName: String
    let locationName: String
    
    private enum CodingKeys: String, CodingKey{
        case organizationName
        case premiseName
        case locationName
    }
}
