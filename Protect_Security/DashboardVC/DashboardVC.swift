//
//  DashboardVC.swift
//  Protect_Security
//
//  Created by Jatin Garg on 19/12/18.
//  Copyright © 2018 Jatin Garg. All rights reserved.
//

import UIKit
import Firebase

class DashboardVC: UIViewController {
    @IBOutlet var actionImages: [InteractiveImageview]!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var imgLogo: UIImageView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var logoWidthConst: NSLayoutConstraint!
    @IBOutlet weak var logoHeightContaint: NSLayoutConstraint!
    
    private var listItem: BadgeBarButtonItem!
    private var chatsItem: BadgeBarButtonItem!
    private var beaconManager: BeaconManager?
    private var emergencyContactNum = ""
    private var isAnyLocationNotFound = false
    
    private var lastMajorID: NSNumber? {
        return beaconManager?.previouslyRangedBeacon?.major
    }
    private var lastMinorID: NSNumber? {
        return beaconManager?.previouslyRangedBeacon?.minor
    }
    
    private var privateQueue: OperationQueue = {
        let q = OperationQueue()
        q.maxConcurrentOperationCount = 1
        return q
    }()
    
    private var previousTrackingOperation: UserTrackingOperation?
    
    private var didRangeAnyBeacons: Bool {
        return
            !(lastMajorID == nil && lastMinorID == nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        #if Protect_Security
        configureNavigationBar()
        setupBadgeObservation()
        getBadgeCount()
        #elseif Protect_User
        self.navigationItem.setHidesBackButton(true, animated:true)
        #endif
        resizeLogoIconFor5S()
        startBeaconRangingProcess()
        actionImages.forEach {
            $0.delegate = self
        }
        locationLabel.startBlinking()
    navigationController?.navigationBar.setBackgroundImage(UIImage(),for: .default)
    }
    
    private func resizeLogoIconFor5S(){
        if UIDevice().userInterfaceIdiom == .phone {
            switch UIScreen.main.bounds.size.height{
            case 480,568:
                print("iPhone 4S", "iPhone 5","iPhone SE")
                logoHeightContaint.constant = 70
                logoWidthConst.constant = 250
                imgLogo.image = UIImage(named: "dashLogo_Small")
                view.layoutIfNeeded()
                
            default:
                print("other models")
            }
        }
    }

    private func configureNavigationBar() {
        
        #if Protect_Security
        guard let menuimage = UIImage(named: "menu"),
            let listimage = UIImage(named: "calendar"),
            let chatsimage = UIImage(named: "message-square")
            else {
                return
        }
        
        let menuItem = UIBarButtonItem(image: menuimage, style: .plain, target: self, action: #selector(menuTapped))
        chatsItem = BadgeBarButtonItem(image: chatsimage, style: .plain, target: self, action: #selector(chatsTapped))
        listItem = BadgeBarButtonItem(image: listimage, style: .plain, target: self, action: #selector(listTapped))
        navigationItem.leftBarButtonItem = menuItem
        navigationItem.rightBarButtonItems = [chatsItem, listItem]
        #endif
    }
    
    private func startBeaconRangingProcess() {
        /*
         1. Ask server for UUID that needs to be ranged.
         1.1. If UUID is returned, save it in user preferences.
         1.2. If not, search for pre-existing UUID in user preferences.
         1.2.1. If found, use that uuid for ranging.
         1.2.2. If not, present error that ranging cannot begin and exit.
         2. Start becon monitoring with that UUID.
         */
        
        let getUUID = GetBeaconUUIDService()
        
        getUUID.fire { (model, error) in
            if let uuid = model?.beaconUUID {
                self.initBeconManager(withUUID: uuid)
                UserPreferences.uuid = uuid
            } else {
                guard let prestoredUUID = UserPreferences.uuid else {
                    System.showInfo(withMessage: Strings.beaconUUIDNotAvailable, ofType: .error, onVC: self)
                    return
                }
                self.initBeconManager(withUUID: prestoredUUID)
            }
        }
    }
    
    private func initBeconManager(withUUID uuid: String) {
        beaconManager = BeaconManager(uuid: uuid)
        beaconManager?.delegate = self
        beaconManager?.requestAuth() //will start beacon ranging logic
    }
    
    #if Protect_Security
    @objc func menuTapped(_ sender: UIBarButtonItem) {
        menuAnimationController?.showMenu()
    }
    
    @objc func chatsTapped(_ sender: UIBarButtonItem) {
        let chatsVC = RecentChatsViewController()
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationController?.pushViewController(chatsVC, animated: true)
    }
    
    @objc func listTapped(_ sender: UIBarButtonItem) {
        navigationController?.pushViewController(IncidentListingVC(), animated: true)
    }
    
    private func getBadgeCount(){
        BadgeUpdater.doyourThing()
    }
    
    private func setupBadgeObservation() {
        NotificationCenter.default.addObserver(self, selector: #selector(chatBadgeChanged), name: BadgeManager.shared.chatBadgeChanged, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(reportBadgeChanged), name: BadgeManager.shared.reportBadgeChanged, object: nil)
    }
    
    @objc func chatBadgeChanged(_ notification: Notification) {
        guard let count = notification.object as? Int else {
            return
        }
        chatsItem.badgeNumber = count
    }
    
    @objc func reportBadgeChanged(_ notification: Notification) {
        guard let count = notification.object as? Int else {
            return
        }
        listItem.badgeNumber = count
    }
    #endif
}

extension DashboardVC: BeaconManagerDelegate {
    func didExitBeaconRegion() {
        
    }
    
    func shouldPresent(_ alert: UIAlertController) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: {
            let isAlertPresent = self.presentedViewController as? UIAlertController != nil
            if isAlertPresent {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: {
                    self.shouldPresent(alert)
                })
            }else{
                self.present(alert, animated: true)
            }
        })
    }
    
    func didRangeNearestBeacon(withMajorID majorID: NSNumber, andMinorID minorID: NSNumber) {
        /*
         1. Check if application has previously ranged some beacons
         1.1. Update text to "updating" if it hasn't
         2. Schedule tracking operation, start blinking and wait for its completion
         2.1. If error, display error and exit
         2.1. Check if orgs subscription is active
         2.1.1. If subscription is active, update location in interface and stop blinking
         2.1.2. If not, display subscription inactive, do following:
         2.1.2.1. Display sub inactive message
         2.1.2.2. Stop beacon ranging service
         */
        
        locationLabel.text = "Updating"
        locationLabel.startBlinking()
        
        let newTrackingOperation = UserTrackingOperation(minorID: minorID, majorID: majorID)
        newTrackingOperation.completionBlock = { [weak self] in
            guard let `self` = self else { return }
            
            DispatchQueue.main.async {
                guard newTrackingOperation.error == nil else {
                    self.locationLabel.text = newTrackingOperation.error!.localizedDescription
                    self.locationLabel.stopBlinking()
                    self.isAnyLocationNotFound = true
                    return
                }
                self.isAnyLocationNotFound = false
                guard let newLocation = newTrackingOperation.userLocation else {
                    return
                }
                
                if newLocation.organization.subscriptionStatus == .inactive {
                    self.beaconManager?.stopMonitoring()
                    self.locationLabel.text = Strings.subscriptionExpiry
                    self.locationLabel.stopBlinking()
                    return
                }
                self.emergencyContactNum = newLocation.emergencyContact ?? ""
                self.locationLabel.text = newLocation.formattedlocation
                self.locationLabel.stopBlinking()
            }
        }
        privateQueue.cancelAllOperations()
        privateQueue.addOperation(newTrackingOperation)
    }
}

extension DashboardVC: InteractiveImageviewDelegate {
    func imageTapped(_ sender: InteractiveImageview) {
        var incidentType: IncidentType?
        switch sender.tag {
        case 0:
            incidentType = .police
            //police
            break
        case 1:
            incidentType = .fire
            //fire
            
            break
        case 2:
            incidentType = .medical
            //medical
            
            break
        case 3:
            incidentType = .general
            //general
            break
        default:
            break
        }
        
        guard let type = incidentType else {
            return
        }
        
        guard let major = lastMajorID, let minor = lastMinorID else {
            //ask user to come near a beacon
            System.showInfo(withMessage: Strings.beaconAbsent, ofType: .error, onVC: self)
            return
        }
        
        if isAnyLocationNotFound {
            confirmBeforeCallToPolice()
        } else {
            //ask for confirmation
            let confirmationDialog = UIAlertController(title: Strings.confirmReportingTitle,
                                                       message: String(format: Strings.confirmReportingMessage(forIncidentType: type),
                                                                       type.rawValue),
                                                       preferredStyle: .alert)
            confirmationDialog.addAction(UIAlertAction(title: "Yes", style: .default, handler: { _ in
                //send report
                IndicatorView.showOver(self.view)
                let service = ReportIncidentService(incidentType: type, majorID: major, minorID: minor)
                service.fire({ (organizationStructure, error) in
                    IndicatorView.hideFrom(self.view)
                    if error != nil {
                        System.showInfo(withMessage: error!.localizedDescription, ofType: .error, onVC: self)
                    } else {
                        let premiseName = organizationStructure!.premiseName
                        let locationName = organizationStructure!.locationName
                        
                        let finalMessage = String(format: Strings.reportSuccessMessage, locationName, premiseName)
                        
                        if sender.tag != 0 {
                            System.showInfo(withMessage: finalMessage, ofType: .information, onVC: self)
                        } else {
                            self.showConfirmationPopup(finalMessage: finalMessage, emergencyNumber: self.emergencyContactNum)
                        }
                    }
                })
            }))
            confirmationDialog.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
            present(confirmationDialog, animated: true)
        }
    }
}

//#MARK: Confirmation Alerts 
extension DashboardVC {
    private func showConfirmationPopup(finalMessage: String, emergencyNumber:String){
        let alertController = UIAlertController(title: InfoType.information.title, message: finalMessage, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default) {
            UIAlertAction in
            self.callToEmergencyNumber(emergencyNumber: emergencyNumber)
            return
        }
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    private func callToEmergencyNumber(emergencyNumber: String) {
        let alertController = UIAlertController(title: InfoType.information.title, message: Strings.emergencyCallMessage, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Yes", style: UIAlertActionStyle.default) {
            UIAlertAction in
            self.calingForEmergency(emergencyNumber: emergencyNumber)
            return
        }
        let cancelAction = UIAlertAction(title: "No", style: UIAlertActionStyle.cancel) {
            UIAlertAction in
            // Cancelled
        }
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    private func calingForEmergency(emergencyNumber: String){
        if emergencyNumber.isValid(regex: .phone) {
            emergencyNumber.makeAColl()
        } else {
            System.showInfo(withMessage: "Invalid emergency contact number.", ofType: .information, onVC: self)
        }
    }
    
    private func confirmBeforeCallToPolice(){
        let alertController = UIAlertController(title: InfoType.information.title, message: Strings.beaconAbsentConfirmationMessage, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Yes", style: UIAlertActionStyle.default) {
            UIAlertAction in
            System.dialNumber(number:"911")
            return
        }
        let cancelAction = UIAlertAction(title: "No", style: UIAlertActionStyle.cancel) {
            UIAlertAction in
            // Cancelled
        }
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
}
