//
//  GetBeaconUUIDService.swift
//  Protect_Security
//
//  Created by Harish Chandra Singh on 04/01/2019.
//  Copyright © 2019 Jatin Garg. All rights reserved.
//
//#MARK: Get installed Beacon UUID

import Foundation

class GetBeaconUUIDService: NetworkRequest {
    
    typealias T = GetUUIDModel
    
    var path: String {
        return APIConfig.getBeaconUUID
    }
    
    var method: RequestType {
        return .get
    }
    var params: [String : Any] {
        return [:]
    }
}
