//
//  GetBadgeService.swift
//  Protect_Security
//
//  Created by Harish Chandra Singh on 21/01/2019.
//  Copyright © 2019 Jatin Garg. All rights reserved.
//
//#MARK: Get the Bage counts for Chat notification and incident report saperatily

import Foundation

class GetBadgeService: NetworkRequest {

    var method: RequestType = .get
    
    var path: String = APIConfig.getBadgeCount
    
    var params: [String : Any] {
        return [:]
    }
    
    typealias T = GetBadgeCountModel
}
