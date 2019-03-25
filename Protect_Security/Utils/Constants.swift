//
//  Constants.swift
//  Protect_Security
//
//  Created by Jatin Garg on 18/12/18.
//  Copyright © 2018 Jatin Garg. All rights reserved.
//

import UIKit

struct Constants{
    static let COUNTRY_CODE = "+1"
    static let UNKNOWN_TARGET = "Target Unknown"
    static let NOTIF_APPROVE = "No, i'm not sure"
    static let NOTIF_DENIED = "Yes, i'm sure"
    static let BT_KEEP_OFF = "No - Keep Location Services Off"
    static let BT_TURN_ON = "Yes - Grant Permission"
    static let BT_SETTINGS_URL = URL(string: "App-Prefs:root=Bluetooth")
    static let APP_SETTINGS_URL = URL(string: UIApplicationOpenSettingsURLString)
    static let BEACON_IDENTIFIER = "PROTECT_BEACON_REGION"
    static let FIREBASE_CHAT_BRANCH_KEY = "protect_chat"
    static let UTC_TIME_ZONE_FORMAT = "yyyy-MM-dd HH:mm:ss'Z'"
}
