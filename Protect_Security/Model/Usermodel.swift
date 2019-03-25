//
//  UserModel.swift
//  Protect_Security
//
//  Created by Jatin Garg on 22/12/18.
//  Copyright © 2018 Jatin Garg. All rights reserved.
//

import Foundation

struct Usermodel: Codable {
    
    public var id: Int
    public var name: String?
    public var profileImageURL: String?
    public var email: String?
    public var contactNumber: String?
    public var token: String?
    public var shouldCreatePassword: Bool?
    
    private enum CodingKeys: String, CodingKey {
        case id = "userID"
        case name
        case profileImageURL
        case email = "emailAddress"
        case contactNumber
        case shouldCreatePassword
        case token
    }
}
