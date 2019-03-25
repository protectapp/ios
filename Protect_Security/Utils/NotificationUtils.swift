//
//  NotificationUtils.swift
//  Protect_Security
//
//  Created by Jatin Garg on 19/12/18.
//  Copyright © 2018 Jatin Garg. All rights reserved.
//

import UserNotifications
import UIKit

class NotificationUtils: NSObject, UNUserNotificationCenterDelegate {
    
    public func scheduleLocalNotification(withTitle title: String, message: String) {
        let localNotificationContent = UNMutableNotificationContent()
        localNotificationContent.title = title
        localNotificationContent.body = message
        localNotificationContent.subtitle = System.appName ?? "Unknown"
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.5, repeats: false)
        let request = UNNotificationRequest(identifier: "Protect Notification", content: localNotificationContent, trigger: trigger)
    
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
    
    public func registerForPushNotifications() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge
        ]) { (granted, error) in
            if !granted {
                self.presentNotificationAlert()
            }else{
                self.getNotificationSettings()
            }
        }
    }
    
    public func didRegisterForRemoteNotifications(deviceToken token: String) {
        print("Registered for notifications, device token is: \(token)")
    }
    
    public func didFailToRegisterForRemoteNotifications(error: Error) {
        print("failed to register for notifications, error: \(error.localizedDescription)")
    }
    
    private func getNotificationSettings() {
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            DispatchQueue.main.async {
                guard settings.authorizationStatus == .authorized else {
                    self.presentNotificationAlert()
                    return
                }
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }
    
    private func presentNotificationAlert(){
        //present a dialog box asking user to goto settings and enable notifications
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            let notificationAlert = UIAlertController(title: "Permission Needed", message: Strings.notificationPermission, preferredStyle: .alert)
            notificationAlert.addAction(UIAlertAction(title: Constants.NOTIF_DENIED, style: .default, handler: nil))
            notificationAlert.addAction(UIAlertAction(title: Constants.NOTIF_APPROVE, style: .default, handler: { _ in
                if let appSettings = Constants.APP_SETTINGS_URL {
                    UIApplication.shared.open(appSettings, options: [:], completionHandler: nil)
                }
            }))
            System.getPresentedViewController()?.present(notificationAlert, animated: true, completion: nil)
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
    
        #if Protect_Security

        let parser = NotificationParser(rawPayload: notification.request.content.userInfo)
        let reportNotification = parser.getNotificationPayload(usingModelClass: IncidentReportModel.self)
        let chatNotification = parser.getNotificationPayload(usingModelClass: ChatContactModel.self)
        
        var shouldShowBanner = true
        if reportNotification != nil {
            //check if user is on reports listing
            if System.currentViewController as? IncidentListingVC != nil {
                shouldShowBanner = false
            }else{
                BadgeManager.shared.incrementBadgeCount(for: .report)
            }
        }

        if chatNotification != nil {
            //check if chatlog is open any user is chatting with notification sender
            if let chatLog = System.currentViewController as? ChatLogVC, let sender = chatNotification!.notificationContent?.id {
                let receiverID = chatLog.chatPartner.id
                if receiverID == sender{
                    shouldShowBanner = false
                }else{
                    BadgeManager.shared.incrementBadgeCount(for: .chat)
                }
            }else{
                if let recentChatsVC = System.currentViewController as? RecentChatsViewController {
                    recentChatsVC.updateRecentList(notification: Notification(name: Notification.Name(rawValue: "Whatever"), object: chatNotification!.notificationContent!, userInfo: nil))
                }
                BadgeManager.shared.incrementBadgeCount(for: .chat)
            }
        }
        
        if shouldShowBanner {
            completionHandler([.alert, .badge, .sound])
        }else{
            completionHandler([])
        }
        #endif
    }

    public static var shared: NotificationUtils {
        return NotificationUtils()
    }
    
    override init() {
        super.init()
        UNUserNotificationCenter.current().delegate = self
    }
}
