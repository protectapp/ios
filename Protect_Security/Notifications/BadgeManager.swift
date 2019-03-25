//
//  BadgeManager.swift
//  Protect_Security
//
//  Created by Jatin Garg on 16/01/19.
//  Copyright © 2019 Jatin Garg. All rights reserved.
//

import UIKit

enum BadgeType {
    case report, chat
}

class BadgeManager: NSObject {
    @objc dynamic var reportBadgeCount: Int {
        get {
            return UserDefaults.standard.value(forKey: "reportBadges") as? Int ?? 0
        }set{
            UserDefaults.standard.set(newValue, forKey: "reportBadges")
            NotificationCenter.default.post(name: reportBadgeChanged, object: newValue)
            updateApplicationBadge()
        }
    } //indicates total number of unseen incident reports
    
    @objc dynamic var chatBadgeCount: Int {
        get{
            return UserDefaults.standard.value(forKey: "chatBadges") as? Int ?? 0
        }set{
            UserDefaults.standard.set(newValue, forKey: "chatBadges")
            NotificationCenter.default.post(name: chatBadgeChanged, object: newValue)
            updateApplicationBadge()
        }
    } //indicates total number of senders that have >0 unread count for this user
    
    private func updateApplicationBadgeIcon() {
        let totalBadges = reportBadgeCount + chatBadgeCount
        UIApplication.shared.applicationIconBadgeNumber = totalBadges
    }
    
    public static let shared = BadgeManager()
    
    public func incrementBadgeCount(for badgeType: BadgeType) {
        switch badgeType {
            case .chat:
                chatBadgeCount += 1
            case .report:
                reportBadgeCount += 1
        }
    }
    
    public func decrementBadgeCount(for badgeType: BadgeType) {
        switch badgeType {
        case .chat:
            chatBadgeCount -= 1
        case .report:
            reportBadgeCount -= 1
        }
    }
    
    public func resetBadgeCount(for badgeType: BadgeType) {
        switch badgeType {
        case .chat:
            chatBadgeCount = 0
        case .report:
            reportBadgeCount = 0
        }
    }
    
    public func getBadCount(for badgeType: BadgeType) -> Int {
        switch badgeType {
        case .chat:
            return chatBadgeCount
        case .report:
            return reportBadgeCount
        }
    }
    
    private func updateApplicationBadge() {
        UIApplication.shared.applicationIconBadgeNumber = chatBadgeCount + reportBadgeCount
    }
    
    public let chatBadgeChanged = Notification.Name(rawValue: "chatbadgechangednotification")
    public let reportBadgeChanged = Notification.Name(rawValue: "reportbadgechangednotification")
}
