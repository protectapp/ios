//
//  IncidentReport.swift
//  Protect_Security
//
//  Created by Jatin Garg on 26/12/18.
//  Copyright © 2018 Jatin Garg. All rights reserved.
//

import UIKit

enum IncidentType: String, Codable {
    
    case fire = "Fire"
    case medical = "Medical"
    case general = "Assist"
    case police = "Police"
    
    public var typeImageName: String {
        switch self {
        case .fire:
            return "PAFire_dash"
        case .medical:
            return "PAMed_dash"
        case .general:
            return "PAAssist_dash"
        case .police:
            return "PALaw_dash"
        }
    }
    
    public var intValue: Int {
        switch self {
        case .fire:
            return 2
        case .medical:
            return 1
        case .police:
            return 3
        case .general:
            return 4
        }
    }
    
    public static func val(fromInt i: Int) throws -> IncidentType  {
        switch i {
        case 1:
            return .medical
        case 2:
            return .fire
        case 3:
            return .police
        case 4:
            return .general
        default:
            throw NSError(domain: "Unknown incident type encountered", code: 101, userInfo: nil)
        }
    }
    
    public var emergencyColor: UIColor {
        switch self {
        case .fire:
            return Color.fireEmergencyColor
        case .medical:
            return Color.medicalEmergencyColor
        case .general:
            return Color.assisColor
        case .police:
            return Color.policEmergencyColor
        }
    }
}

enum IncidentTime: Int, Decodable {
    case today = 1
    case yesterday = 2
    case others = 3
    
    public var stringValue: String {
        switch self {
        case .today:
            return "today"
        case .yesterday:
            return "yesterday"
        case .others:
            return "others"
            
        }
    }
}

struct TimezoneModel: Decodable {
    let date: String
    let timezoneType: Int
    let timezone: String
    
    private let timestampFormat: String = "yyyy-MM-dd HH:mm:ss'Z'"
    private let dateFormat: String = "YYYY-MM-dd"
    private let timeformat: String = "HH:mm"
    
    public var localTimestamp: (date: String, time: String)? {
        let formatter = DateFormatter()
        formatter.dateFormat = timestampFormat
        formatter.timeZone = TimeZone(abbreviation: timezone)
        if let dateObject = formatter.date(from: date){
            formatter.timeZone = TimeZone.current
            formatter.dateFormat = dateFormat
            let localDateString = formatter.string(from: dateObject)
            formatter.dateFormat = timeformat
            let localTimeString = formatter.string(from: dateObject)
            return (date: localDateString, time: localTimeString)
        }
        return nil
        
    }
    private enum CodingKeys: String, CodingKey {
        case date
        case timezoneType = "timezone_type"
        case timezone
    }
}

struct IncidentReportModel: Decodable {
    let id: Int
    let type: IncidentType
    let location: String
    let premise: String
    let venue: String
    let date: String
    let time: String
    let attendees: [Usermodel]
    let reportedBy: Usermodel
    var isCollapsed: Bool? = true
    var timestamp:String? = ""

    public var completeLocation: String {
        return "\(venue), \(premise), \(location)"
    }
    static let timestampformat: String = "yyyy-MM-dd HH:mm:ss'Z'"
    static let dateFormat: String = "yyyy-MM-dd"
    static let timeformat: String = "hh:mm a"

    public var formattedTimeStamp: String? {

        let timestamp = date + " " + time

        let formatter = DateFormatter()
        formatter.dateFormat = IncidentReportModel.dateFormat + " " + IncidentReportModel.timeformat

        guard let date = formatter.date(from: timestamp) else {
            return nil
        }
        let string = date.getElapsedInterval()
        if string != "Today" {
            return string + " ago"
        }
        
        return string
    }
    
    init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        
        let incidentType = try container.decode(Int.self, forKey: .type)
        type = try IncidentType.val(fromInt: incidentType)
        location = try container.decode(String.self, forKey: .location)
        premise = try container.decode(String.self, forKey: .premise)
        venue = try container.decode(String.self, forKey: .venue)

        var timeString = try container.decode(String.self, forKey: .timestamp)
        timestamp = timeString
        timeString = timeString.UTCToLocal(incomingFormat: Constants.UTC_TIME_ZONE_FORMAT, outGoingFormat: IncidentReportModel.timestampformat)
        
        let formatter = DateFormatter()
        formatter.dateFormat = Constants.UTC_TIME_ZONE_FORMAT
        let convertedDate = formatter.date(from: timeString)!
        formatter.dateFormat = IncidentReportModel.dateFormat

        date = formatter.string(from: convertedDate)
        formatter.dateFormat = IncidentReportModel.timeformat
        time = formatter.string(from: convertedDate)
       
        attendees = try container.decode([Usermodel].self, forKey: .attendees)
        reportedBy = try container.decode(Usermodel.self, forKey: .reportedBy)
    }
    
    private enum CodingKeys: String, CodingKey {
        case id = "reportID"
        case type = "type"
        case location = "location"
        case premise = "premise"
        case venue = "organization"
        case timestamp = "timestamp"
        case attendees = "attendedBy"
        case reportedBy = "initiatedBy"
        case isCollapsed
    }
}


