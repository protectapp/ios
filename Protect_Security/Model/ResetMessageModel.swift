//
//  ResetMessageModel.swift
//  Protect_Security
//
//  Created by Harish Chandra Singh on 16/01/2019.
//  Copyright © 2019 Jatin Garg. All rights reserved.
//

import Foundation

struct ResetMessageModel : Codable {
    
    public var nodeIdentifier : String
    public var timestampOfLastMessage: String
    public var unreadMessages: Int?
    
    private enum CodingKeys: String, CodingKey {
        case nodeIdentifier
        case timestampOfLastMessage
        case unreadMessages
    }
}
