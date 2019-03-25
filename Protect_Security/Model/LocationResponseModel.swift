//
//  LocationResponseModel.swift
//  Protect_Security
//
//  Created by Jatin Garg on 08/01/19.
//  Copyright © 2019 Jatin Garg. All rights reserved.
//

import Foundation

enum SubscriptionStatus: String, Codable {
    case active = "active"
    case inactive = "inactive"
}

struct OrganizationModel: Decodable {
    let id: Int
    let name: String
    let subscriptionStatus: SubscriptionStatus
    
    private enum CodingKeys: String, CodingKey{
        case id
        case name
        case subscriptionStatus
    }
}

struct LocationResponseModel: Decodable{
    let organization: OrganizationModel
    let premise: String?
    let locationName: String?
    let emergencyContact: String?
    
    public var formattedlocation: String {
        if premise == nil {
            if locationName == nil {
                return organization.name
            }else{
                return "\(organization.name), \(locationName!)"
            }
        }else{
            if locationName == nil {
                return "\(organization.name), \(premise!)"
            }else{
                return "\(organization.name), \(premise!), \(locationName!)"
            }
        }
    }
    private enum CodingKeys: String, CodingKey {
        case organization
        case premise
        case locationName
        case emergencyContact
    }
}
