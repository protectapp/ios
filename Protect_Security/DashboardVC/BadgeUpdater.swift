//
//  BadgeUpdater.swift
//  Protect_Security
//
//  Created by Harish Chandra Singh on 30/01/2019.
//  Copyright © 2019 Jatin Garg. All rights reserved.
//

import Foundation

class BadgeUpdater{
    public static func doyourThing() {
        let service = GetBadgeService()
        service.fire { (model, error) in
            if let badgeResponse = model{
                guard
                    let chatBadgeCount = badgeResponse.chat_badge_count,
                    let incidentBadgeCout = badgeResponse.incident_badge_count
                    else{
                        return
                }
                BadgeManager.shared.chatBadgeCount = chatBadgeCount
                BadgeManager.shared.reportBadgeCount = incidentBadgeCout
            }
        }
    }
}
