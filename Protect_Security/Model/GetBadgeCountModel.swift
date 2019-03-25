//
//  GetBadgeCountModel.swift
//  Protect_Security
//
//  Created by Harish Chandra Singh on 21/01/2019.
//  Copyright © 2019 Jatin Garg. All rights reserved.
//

import Foundation

struct GetBadgeCountModel : Codable {
    
    public var chat_badge_count: Int?
    public var incident_badge_count: Int?
    public var total_badge: Int?
    
    private enum CodingKeys: String, CodingKey {
        case chat_badge_count
        case incident_badge_count
        case total_badge
    }
}
