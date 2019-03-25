//
//  IncidentListingViewModel.swift
//  Protect_Security
//
//  Created by Jatin Garg on 10/01/19.
//  Copyright © 2019 Jatin Garg. All rights reserved.
//

import Foundation

class IncidentListingViewModel {
    public var sections: [IncidentListingSectionModel]
    
    init(sections: [IncidentListingSectionModel]) {
        self.sections = sections
    }
}
