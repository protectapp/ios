//
//  GetCMSContent.swift
//  Protect_Security
//
//  Created by Harish Chandra Singh on 27/12/2018.
//  Copyright © 2018 Jatin Garg. All rights reserved.
//

import Foundation

struct GetCMSContent: Decodable, Encodable {
    
    public var data: String?

    private enum CodingKeys: String, CodingKey {
        case data = "PAGE"
    }
}
