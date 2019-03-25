//
//  RecordResponseModel.swift
//  Protect_Security
//
//  Created by Harish Chandra Singh on 08/02/2019.
//  Copyright © 2019 Jatin Garg. All rights reserved.
//

import Foundation
struct RecordResponseModel : Codable {
    
    public var id:Int?
    public var aid_request_id:Int?
    public var updated_at:String?
    
    private enum CodingKeys: String, CodingKey {
        case id
        case aid_request_id
        case updated_at
    }
}
