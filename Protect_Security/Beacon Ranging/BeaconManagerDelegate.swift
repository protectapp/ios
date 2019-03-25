//
//  BeaconManagerDelegate.swift
//  Protect_Security
//
//  Created by Jatin Garg on 07/01/19.
//  Copyright © 2019 Jatin Garg. All rights reserved.
//

import UIKit

protocol BeaconManagerDelegate: class {
    func shouldPresent(_ alert: UIAlertController)
    func didRangeNearestBeacon(withMajorID majorID: NSNumber, andMinorID minorID: NSNumber)
    func didExitBeaconRegion()
}
