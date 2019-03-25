//
//  TrackUserService.swift
//  Protect_Security
//
//  Created by Jatin Garg on 08/01/19.
//  Copyright © 2019 Jatin Garg. All rights reserved.
//
//#MARK: Get All incident reports which will be shown in Aid history 

import Foundation

class GetIncidentsService: NetworkRequest {
    public var page: Int
    public var type: IncidentTime
    
    init(page: Int, type: IncidentTime) {
        self.page = page
        self.type = type
    }
    
    var method: RequestType = .get
    
    var path: String = APIConfig.getIncidents
    
    var params: [String : Any] {
        return [
            "page" : page,
            "type" : type.stringValue
        ]
    }
    
    typealias T = IncidentListingModel
}
