//
//  Strings.swift
//  Protect_Security
//
//  Created by Jatin Garg on 19/12/18.
//  Copyright © 2018 Jatin Garg. All rights reserved.
//

import UIKit

struct Strings {
    public static var OTPRequestTitle: String {
        #if Protect_Security
            return "Forgot Password?"
        #elseif Protect_User
            return "OTP Verification"
        #else
            return Constants.UNKNOWN_TARGET
        #endif
    }
    
    public static var OTPRequestMessage: NSAttributedString {
        #if Protect_Security
            return NSAttributedString(string: "Please enter your registered mobile number, we will provide you an OTP to reset your password")
        #elseif Protect_User
            let mainString = "We will send you a One Time Password"
            let subString = "One Time Password"
            let range = (mainString as NSString).range(of: subString)
            let attribString = NSMutableAttributedString(string: mainString)
                attribString.addAttribute(.font, value: Font.font(ofSize: 16, andFace: .semiBold), range: range)
            return attribString
        #else
            return NSAttributedString(string: Constants.UNKNOWN_TARGET)
        #endif
    }
    
    public static var notificationPermission: String {
        let appName = System.appName ?? "Unknown"
        var message: String!
        #if Protect_Security
            message = "\(appName) uses notifications to let you know about new aid requests and nearby beacons.\n"
        #elseif Protect_User
            message = "\(appName) uses notifications to let you know about nearby locations in the venue you visit.\n "
        #else
            return Constants.UNKNOWN_TARGET
        #endif
        
        return message + "Are you sure you don't want to see notifications?"
    }
    
    public static var bluetoothTurnedOff: String {
        let appName = System.appName ?? "Unknown"
        var message: String!
        
        #if Protect_Security
            message = "\(appName) needs your bluetooth to be turned on in order to determine your location in an emergency and to record your response to aid requests."
        #elseif Protect_User
            message = "\(appName) needs your bluetooth to be turned on in order to determine your location in an emergency."
        #else
            return Constants.UNKNOWN_TARGET
        #endif
        return message + "\nWould you like to turn on bluetooth?"
    }
    
    public static var bluetoothUnsupported: String {
        let appName = System.appName ?? "Unknown"
        return "\(appName) requires properly functioning bluetooth hardware in order to function properly. App might not perform as expected on your device."
    }
    
    public static var bluetoothTurnedOffTitle: String {
        return "Bluetooth Turned Off"
    }
    
    public static var bluetoothUnsupportedTitle: String {
        return "Bluetooth Not Supported"
    }
    
    public static var locationWhenInUseNotAvailableTitle: String {
        return "Location Permission Needed"
    }
    
    public static var locationWhenInUseRequiredMessage: String {
        let appName = System.appName ?? "Unknown"
        var message: String!
        
        #if Protect_Security
            message = "\(appName) needs to access your phone’s location services in order to accurately determine your position within a building. This information is used to dispatch aid if you request help. You are not being tracked. Your phone is being told where it is by Bluetooth beacons."
        #elseif Protect_User
            message = "\(appName) needs to access your phone’s location services in order to accurately determine your position within a building. This information is used to dispatch aid if you request help. You are not being tracked. Your phone is being told where it is by Bluetooth beacons."
        #else
            return Constants.UNKNOWN_TARGET
        #endif
        return message + "\nWould you like to provide 'Always' location usage permission?"
    }
    
    public static var beaconUUIDNotAvailable: String {
        return "We couldn't locate any beacon identifiers. Indoor location services may not work."
    }
    
    public static var beaconAbsent: String {
        return "We couldn't pinpoint your location within this facility. Please make sure that bluetooth is on and location services are available."
    }
    
    public static var beaconAbsentConfirmationMessage: String {
        return "We couldn't pinpoint your location within this facility.Do you want to call on 911 in case of any emergency?"
    }
    public static var emergencyCallMessage: String {
        return "Do you want to call to security member in case of emergency?"
    }
    
    public static var confirmReportingTitle: String {
        return "Please confirm"
    }
    
    public static func confirmReportingMessage(forIncidentType type: IncidentType) -> String {
        var fixedString = "Are you sure"
        
        switch type {
        case .fire:
            fixedString += " that you want to report a fire"
        case .general:
            fixedString += " that you need assistance"
        case .medical:
            fixedString += " that you want to report a medical emergency"
        case .police:
            fixedString += " that you need police assistance"
        }
        fixedString += " at your location?"
        return fixedString
    }
    
    public static var reportSuccessMessage: String {
        return "We have received your report. Someone from the security team will arrive at %@ of %@ soon."
    }
    
    public static var subscriptionExpiry: String {
        return "Subscription expired for this organization"
    }
    
    #if Protect_Security
    public static func incidentsUnavailable(forSection section: IncidentListingSectionModel) -> String {
        var message = "No incidents were reported"
        if section.sectionName == .others {
            message += " in past"
        }else{
            message += " \(section.sectionName.stringValue)"
        }
        return message
    }
    #endif
}
