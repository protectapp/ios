//
//  APIConfig.swift
//  Protect_Security
//
//  Created by Jatin Garg on 22/12/2018.
//  Copyright © 2018 Jatin Garg. All rights reserved.
//

import Foundation

struct APIConfig {
    static let baseURL: String = "https://demo.newmediaguru.co/protect-app/api/"
    static let login: String = "security-login"
    static let changePass : String = "change-password"
    static let getUserProfile : String = "get-user"
    static let updateprofile : String = "update-user-profile"
    static let getCMSContent : String = "page-info"
    static let createPass: String = "update-password"
    static let getOTP: String = "request-otp"
    static let verifyOtp: String = "verify-otp"
    static let notifcnTokenRegister: String = "notification_token_registration"
    static let userLogout: String = "user-logout?deviceToken="
    static let getContacts: String = "get-contacts?page="
    static let getRecentChat: String = "getLastMessage"
    static let getBeaconUUID: String = "get-uuid"
    static let reportIncident: String = "visitor-incident"
    static let trackUser: String = "get-location"
    static let getIncidents: String = "get-incident"
    static let updateLastMessage: String = "updateLastMessage"
    static let resetUnreadCount: String = "resetUnread"
    static let getBadgeCount:String = "total_badge"
    static let recordResponse:String = "records-response"
}
