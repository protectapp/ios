//
//  NotificationType.swift
//  Protect_Security
//
//  Created by Jatin Garg on 15/01/19.
//  Copyright © 2019 Jatin Garg. All rights reserved.
//

import Foundation

enum NotificationType: String, Codable {
    case report = "report"
    case chat = "chat"
    case crone = "cron-report"
}
