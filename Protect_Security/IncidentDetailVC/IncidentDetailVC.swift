//
//  IncidentDetailVC.swift
//  Protect_Security
//
//  Created by Jatin Garg on 28/12/18.
//  Copyright © 2018 Jatin Garg. All rights reserved.
//

import UIKit

class IncidentDetailVC: UIViewController {
    @IBOutlet weak var profileImageHeight: NSLayoutConstraint!
    @IBOutlet weak var incidentTypeImage: UIImageView!
    @IBOutlet weak var incidentLocationLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    
    public var incident: IncidentReportModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        incidentTypeImage.image = UIImage(named: incident.type.typeImageName)
        incidentLocationLabel.text = incident.completeLocation
        
        let incidentTimestamp = incident.timestamp?.UTCToLocal(incomingFormat: Constants.UTC_TIME_ZONE_FORMAT, outGoingFormat: "MMM d, yyyy h:mm a" )
        timeLabel.text = incidentTimestamp
        
        if let userName = incident.reportedBy.name {
            userNameLabel.text = userName
            profileImage.sd_setImage(with: URL(string: incident.reportedBy.profileImageURL ?? ""), placeholderImage: UIImage(named: "chat_placeholder"))
        } else {
            userNameLabel.text = incident.reportedBy.contactNumber!
            profileImageHeight.constant = 0
        }
    }

    @IBAction func closeTapped(_ sender: Any) {
        dismiss(animated: true)
    }
}
