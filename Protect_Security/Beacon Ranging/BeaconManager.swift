//
//  BeaconManage.swift
//  Protect_Security
//
//  Created by Jatin Garg on 20/12/2018.
//  Copyright © 2018 Jatin Garg. All rights reserved.
//

import CoreLocation
import CoreBluetooth
import UIKit

class BeaconManager: NSObject {
    private var uuid: String!
    private let locationManager = CLLocationManager()
    private let bluetoothManager = BluetoothManager()
    private lazy var protectBeaconRegion: CLBeaconRegion? = {
        
        let beaconID = UUID(uuidString: self.uuid)
        
        return CLBeaconRegion(proximityUUID: beaconID!, identifier: Constants.BEACON_IDENTIFIER)
    }()
    public var previouslyRangedBeacon: CLBeacon?
    public weak var delegate: BeaconManagerDelegate?
    
    init(uuid: String) {
        super.init()
        self.uuid = uuid
        locationManager.delegate = self
        bluetoothManager.delegate = self
    }
    
    public func requestAuth() {
        locationManager.requestAlwaysAuthorization()
    }
    
    public func stopMonitoring() {
        locationManager.stopMonitoring(for: protectBeaconRegion!)
        locationManager.stopRangingBeacons(in: protectBeaconRegion!)
        locationManager.stopUpdatingLocation()
    }
    
    private func startMonitoringForBeaconRegion() {
        //protectBeaconRegion!.notifyEntryStateOnDisplay = true
        protectBeaconRegion!.notifyOnExit = true
        protectBeaconRegion!.notifyOnEntry = true
        locationManager.startUpdatingLocation() //needed for ranging beacons in background
        if #available(iOS 11.0, *) {
            locationManager.showsBackgroundLocationIndicator = true
        } else {
            // Fallback on earlier versions
        }
        locationManager.startMonitoring(for: protectBeaconRegion!)
        locationManager.startRangingBeacons(in: protectBeaconRegion!)
    }
}

extension BeaconManager: BluetoothManagerDelegate {
    func didDetermine(bluetoothStateToBe state: CBManagerState) {
        switch state {
        case .poweredOff:
            print("bluetooth off")
            delegate?.shouldPresent(turnOnBTPrompt)
            break
        case .poweredOn:
            print("bluetooth on")
            break
        case .unsupported:
            delegate?.shouldPresent(BTUnsupportedPrompt)
            break
        default:
            break
        }
    }
}

extension BeaconManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways :
            //always permission granted
            startMonitoringForBeaconRegion()
            break
        case .authorizedWhenInUse:
            //in user permission granted
            delegate?.shouldPresent(locationAlwaysOnPermissionPrompt)
            startMonitoringForBeaconRegion()
            break
        case .denied:
            //location is probably off in settings
            delegate?.shouldPresent(locationAlwaysOnPermissionPrompt)
            break
        case .restricted:
            delegate?.shouldPresent(locationAlwaysOnPermissionPrompt)
        case .notDetermined:
            //user hasn't made a choice yet. Let the system dialog appear and do its thing
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didDetermineState state: CLRegionState, for region: CLRegion) {
        switch state {
        case .inside:
            print("inside monitoring region")
            locationManager.startRangingBeacons(in: protectBeaconRegion!)
            break
        case .outside:
            print("outside monitoring region")
            delegate?.didExitBeaconRegion()
            previouslyRangedBeacon = nil
            break
        case .unknown:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        print("did enter beacon region")
        NotificationUtils.shared.scheduleLocalNotification(withTitle: "Beacon state update", message: "Inside beacon region")
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        print("did exit region")
    }
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        /*
         1. Check if the beacon array contains previously ranged beacon.
         1.1. If yes, check if the closes beacon in that array is equal to previously ranged beacon.
         1.1.1. If yes, ignore and return.
         1.1.2. If no, do following:
         a. find out distance of closest beacon from me(da).
         b. find out distance of previously ranged beacon from me(db).
         c. Check if abs(da-db) > buffer.
         c.1. if yes, report beacon change.
         c.2. if no, ignore and keep the previously ranged beacon intact.
         1.2. If no, range the closest beacon normally.
         
         */
        guard let closestBeacon = beacons.first else{
            return
        }
        
        var shouldRange = false
        
        defer {
            if shouldRange {
                self.delegate?.didRangeNearestBeacon(withMajorID: closestBeacon.major, andMinorID: closestBeacon.minor)
                previouslyRangedBeacon = closestBeacon
            }
        }
        guard let beaconA = previouslyRangedBeacon else{
            previouslyRangedBeacon = closestBeacon
            shouldRange = true
            return
        }
        
        let indexOfPreviousBeacon = beacons.index(where: {
            return $0.minor == beaconA.minor && $0.major == beaconA.major
        })
        let wasBeaconARanged = indexOfPreviousBeacon != nil
        
        if wasBeaconARanged {
            if beaconA.major == closestBeacon.major && beaconA.minor == closestBeacon.minor {
                return
            }else{
                let dA = beacons[indexOfPreviousBeacon!].accuracy
                let dB = closestBeacon.accuracy
                let difference = abs(dA - dB)
                if difference > 3.5 {
                    shouldRange = true
                }else{
                    return
                }
            }
        }else{
            shouldRange = true
        }
    }
}

extension BeaconManager {
    //prompts
    private var turnOnBTPrompt: UIAlertController {
        let alert = UIAlertController(title: Strings.bluetoothTurnedOffTitle, message: Strings.bluetoothTurnedOff, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: Constants.BT_KEEP_OFF, style: .destructive, handler: nil))
        alert.addAction(UIAlertAction(title: Constants.BT_TURN_ON, style: .default, handler: { _ in
            //redirect to bt setting
            if let bluetoothSettingURL = Constants.BT_SETTINGS_URL {
                UIApplication.shared.open(bluetoothSettingURL, options: [:], completionHandler: nil)
            }
        }))
        return alert
    }
    
    private var BTUnsupportedPrompt: UIAlertController {
        let alert = UIAlertController(title: Strings.bluetoothUnsupportedTitle, message: Strings.bluetoothUnsupported, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .destructive, handler: nil))
        return alert
    }
    
    private var locationAlwaysOnPermissionPrompt: UIAlertController {
        let alert = UIAlertController(title: Strings.locationWhenInUseNotAvailableTitle, message: Strings.locationWhenInUseRequiredMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: Constants.BT_KEEP_OFF, style: .destructive, handler: nil))
        alert.addAction(UIAlertAction(title: Constants.BT_TURN_ON, style: .default, handler: { _ in
            //redirect to bt setting
            if let applicationSettings = Constants.APP_SETTINGS_URL {
                UIApplication.shared.open(applicationSettings, options: [:], completionHandler: nil)
            }
        }))
        return alert
    }
}
