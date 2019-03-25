//
//  AppDelegate.swift
//  Protect_Security
//
//  Created by Jatin Garg on 13/12/18.
//  Copyright © 2018 Jatin Garg. All rights reserved.
//

import UIKit
import Fabric
import Crashlytics
import Firebase
import FirebaseMessaging

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate{
    
    var window: UIWindow?
    private var isFirstLaunch = true
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
       
        var vcToLoad: UIViewController!
        
        #if Protect_Security
        vcToLoad = System.constructSecurityRoot()
        #elseif Protect_User
        vcToLoad = System.constructUserRoot()
        #endif
        FirebaseApp.configure()
        window?.rootViewController = vcToLoad
        window?.makeKeyAndVisible()
        NotificationUtils.shared.registerForPushNotifications()
        Messaging.messaging().delegate = self
        Fabric.with([Crashlytics.self])
        return true
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
        let token = tokenParts.joined()
        Messaging.messaging().apnsToken = deviceToken
        NotificationUtils.shared.didRegisterForRemoteNotifications(deviceToken: token)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        handeNotification(withUserInfo: userInfo)
    }
    
    private func handeNotification(withUserInfo userInfo: [AnyHashable: Any]) {
        //try and parse using various kinds of model classes and see what fits
        //Todo :- Handle taps on other kinds of notis
        #if Protect_Security
        let notificationParser = NotificationParser(rawPayload: userInfo)
        
        if let reportPayload = notificationParser.getNotificationPayload(usingModelClass: IncidentReportModel.self) {
            guard let incident = reportPayload.notificationContent else {
                return
            }
            if reportPayload.notificationType == .crone{
                let currentVC = System.getPresentedViewController()
                showRecordResponsePopUp(currentVC:currentVC, incidentID: incident.id)
            } else {
                let reportDetailVC = IncidentDetailVC()
                reportDetailVC.incident = incident
                System.getPresentedViewController()?.present(reportDetailVC, animated: true)
            }
        } else if let chatPayload = notificationParser.getNotificationPayload(usingModelClass: ChatContactModel.self) {
            guard
                let menuController = System.getPresentedViewController() as? AnimatedCircularMenuController,
                let navController = menuController.frontViewcontroller as? UINavigationController
                else{
                    return
            }
            navController.popToRootViewController(animated: false)
            let recentChatsVC = RecentChatsViewController()
            navController.pushViewController(recentChatsVC, animated: false)
            guard let chatContact = chatPayload.notificationContent else { return }
            recentChatsVC.launchChatLog(forUser: chatContact)
        }
        #endif
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        NotificationUtils.shared.didFailToRegisterForRemoteNotifications(error: error)
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        //check if chatlog is opened, if yes, reset unread count for that user
        #if Protect_Security
        if let chatLog = System.currentViewController as? ChatLogVC {
            print("need to reset unread count")
            chatLog.resetUnreadCountApiCalling()
        }
        #endif
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        reachabilityManager.stopMonitoring()
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        reachabilityManager.startMonitoring()
        #if Protect_Security
        if isFirstLaunch == false {
            BadgeUpdater.doyourThing()
        }
        isFirstLaunch = false
        #endif
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        
    }
    #if Protect_Security
    private func showRecordResponsePopUp(currentVC:UIViewController?, incidentID:Int){
        let alertController = UIAlertController(title: InfoType.information.title, message: "Do you want to record your response to this incident report?", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Respond", style: UIAlertActionStyle.default) {
            UIAlertAction in
            self.recordSecurityPersonResponse(incidentId:incidentID)
            return
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel) {
            UIAlertAction in
            // Cancelled
        }
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        currentVC?.present(alertController, animated: true, completion: nil)
    }
    
    private func recordSecurityPersonResponse(incidentId:Int){
        let service = RecordResponseService(incidentID: incidentId)
        service.fire { (model, error) in
            if error == nil {
                let toast = iToast(text: "Response recorded successfully.")
                toast.toastLabel.adjustsFontForContentSizeCategory = true
                toast.toastLabel.allowsDefaultTighteningForTruncation = true
                toast.show()
            }
        }
    }
    #endif
}
extension AppDelegate: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        
        print("Firebase registration token: \(fcmToken)")
        UserPreferences.deviceToken = fcmToken
        
        if let _ = UserPreferences.userToken{
            //hit updater token api
            let service = NotifcnTokenRegisterService(deviceToken: fcmToken)
            service.fire { (model, error) in
                if error == nil {
                    print("Token registered")
                }
            }
        }
    }
}


