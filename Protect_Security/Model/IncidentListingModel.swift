//
//  IncidentListingModel.swift
//  Protect_Security
//
//  Created by Jatin Garg on 10/01/19.
//  Copyright © 2019 Jatin Garg. All rights reserved.
//

import Foundation

class ReportSectionModel: Decodable {
    var date: String
    var reports: [IncidentReportModel]
    
    init(date: String, reports: [IncidentReportModel]) {
        self.date = date
        self.reports = reports
    }
    
    private enum CodingKeys: String,CodingKey {
        case date
        case reports
    }
}

class IncidentListingModel: Decodable {
    var reportSections: [ReportSectionModel]
    var currentPage: Int
    var totalPages: Int
    var recordsPerPage: Int
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        currentPage = try container.decodeIfPresent(Int.self, forKey: .currentPage) ?? 0
        totalPages = try container.decodeIfPresent(Int.self, forKey: .totalPages) ?? 0
        recordsPerPage = try container.decodeIfPresent(Int.self, forKey: .recordsPerPage) ?? 0
        var tempReports: [ReportSectionModel] = []
        //big stuff
        let incidentReports = try container.decode([IncidentReportModel].self, forKey: .reports)
        let dates: [String] = incidentReports.map({
            $0.date
        })
        
        var uniqueDates: [String] = []
        for date in dates {
            if !uniqueDates.contains(date) {
                uniqueDates.append(date)
            }
        }
        
        for uniqueDate in uniqueDates {
            let specificReports = incidentReports.filter({
                $0.date == uniqueDate
            })
            
            if specificReports.count > 0 {
                tempReports.append(ReportSectionModel(date: uniqueDate, reports: specificReports))
            }
        }
        reportSections = tempReports
    }
    
    private enum CodingKeys: String, CodingKey {
        case reports
        case currentPage
        case totalPages
        case recordsPerPage
    }
}
