//
//  RecordResponseService.swift
//  Protect_Security
//
//  Created by Harish Chandra Singh on 07/02/2019.
//  Copyright © 2019 Jatin Garg. All rights reserved.
//
//#MARK: Manual Attendee marking when we get notification in every 10 minutes

import Foundation

class RecordResponseService: NetworkRequest {
    
    private let incidentID: Int
    
    init(incidentID: Int) {
        self.incidentID = incidentID
    }
    
    typealias T = RecordResponseModel
    
    var path: String {
        return APIConfig.recordResponse
    }
    var method: RequestType {
        return .post
    }
    var params: [String : Any] {
        return ["incidentID": incidentID]
    }
}
