//
//  ReportIncidentService.swift
//  Protect_Security
//
//  Created by Jatin Garg on 07/01/19.
//  Copyright © 2019 Jatin Garg. All rights reserved.
//
//#MARK: Incident Report 

import Foundation

class ReportIncidentService: NetworkRequest {
    private let incidentType: IncidentType
    private let majorID: NSNumber
    private let minorID: NSNumber
    
    init(incidentType: IncidentType, majorID: NSNumber, minorID: NSNumber) {
        self.incidentType = incidentType
        self.majorID = majorID
        self.minorID = minorID
    }
    
    var method: RequestType = .post
    
    var path: String = APIConfig.reportIncident
    
    var params: [String : Any] {
        return [
            "incidentType" : incidentType.intValue,
            "majorID" : majorID,
            "minorID" : minorID
        ]
    }
    typealias T = OrganizationStructure
}
