//
//  IncidentListingViewModel.swift
//  Protect_Security
//
//  Created by Jatin Garg on 10/01/19.
//  Copyright © 2019 Jatin Garg. All rights reserved.
//

import Foundation

class IncidentListingSectionModel {
    public var sectionName: IncidentTime
    public var incidents: IncidentListingModel?
    public var canFetchMore = true
    
    init(sectionName: IncidentTime, incidents: IncidentListingModel?) {
        self.sectionName = sectionName
        self.incidents = incidents
    }
}
