//
//  ReachabilityManager.swift
//  Protect_Security
//
//  Created by Jatin Garg on 21/01/19.
//  Copyright © 2019 Jatin Garg. All rights reserved.
//

import Foundation
import Reachability

class ReachabilityManager: NSObject {
    static let shared = ReachabilityManager()
    
    private var isNetworkAvailable: Bool {
        return reachabilityStatus != .none
    }
    
    private var reachabilityStatus: Reachability.Connection = .none
    private let reachability = Reachability()
    private let banner = ReachabilityBanner()
    private var timer: Timer?
    
    @objc private func reachabilityChanged(_ notification: Notification) {
        guard let reachability = notification.object as? Reachability else {
            return
        }
        reachabilityStatus = reachability.connection
        switch reachability.connection {
        case .none:
            print("Network is unreachable")
        case .wifi:
            print("Network reachable via wifi")
        case .cellular:
            print("Network reachable via cellular")
        }
        
        setupNetworkBanner(withNetworkAvailable: isNetworkAvailable)
    }
    
    private func setupNetworkBanner(withNetworkAvailable networkAvailable: Bool) {
        var currentViewController: UIViewController?
        
        #if Protect_Security
        currentViewController = System.currentViewController
        #elseif Protect_User
        currentViewController = ((UIApplication.shared.delegate as? AppDelegate)?.window?.rootViewController as? UINavigationController)?.viewControllers.last
        #endif
        
        guard let vc = currentViewController else {
            print("Couldn't figure out which vc to present the banner on")
            return
        }
        banner.isNetworkReachable = networkAvailable
        
        if isNetworkAvailable {
            //start out the 5 second timer
            timer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: false, block: { (timer) in
                self.banner.removeFromCurrentView()
            })
        }else{
            timer?.invalidate()
        }
        banner.addOver(vc)
    }
    
    public func startMonitoring() {
        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged), name: .reachabilityChanged, object: reachability)
        do {
            try reachability?.startNotifier()
        }catch {
            print("Failed to start reachability monitoring: \(error)")
        }
    }
    
    public func stopMonitoring() {
        reachability?.stopNotifier()
        NotificationCenter.default.removeObserver(self, name: .reachabilityChanged, object: reachability)
    }
}

let reachabilityManager = ReachabilityManager.shared
