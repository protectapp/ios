//
//  NotificationPayload.swift
//  Protect_Security
//
//  Created by Jatin Garg on 15/01/19.
//  Copyright © 2019 Jatin Garg. All rights reserved.
//

import Foundation

struct NotificationPayloadModel<T: Decodable>: Decodable {
    public var notificationType: NotificationType?
    public var notificationContent: T?
    
    private enum CodingKeys: String, CodingKey {
        case notificationType = "notification-type"
        case notificationContent = "payload"
    }
}
