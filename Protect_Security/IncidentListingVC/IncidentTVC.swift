//
//  IncidentTVC.swift
//  Protect_Security
//
//  Created by Jatin Garg on 26/12/18.
//  Copyright © 2018 Jatin Garg. All rights reserved.
//

import UIKit

class IncidentTVC: UITableViewCell {
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var attendeeContainerNoHeightConstriant: NSLayoutConstraint!
    @IBOutlet weak var attendeeContainer: AttendeeContainer!
    @IBOutlet weak var ribbonView: UIView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var incidentLocationLabel: UILabel!
    @IBOutlet weak var incidentTypeLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    
    public static let viewmodeChangeNoti = Notification.Name("IncidentCellViewModeChangedNotification")
    public var incident: IncidentReportModel! {
        didSet{
            configureCell()
        }
    }
    
    public var myIndexPath: IndexPath!
    public weak var myTableview: UITableView?
    public var moreTapHandler: (()->())?
    
    private func configureCell() {
        incidentTypeLabel.text = incident.type.rawValue
        incidentLocationLabel.text = incident.venue + ", " + incident.premise + ", " + incident.location
        let attendees = incident.attendees
        attendeeContainer.containerMode = incident.isCollapsed! ? .collapsed : .expanded
        attendeeContainer.attendees = attendees
        timeLabel.text = incident.time
        ribbonView.backgroundColor = incident.type.emergencyColor
        attendeeContainer.moreTappedHandler = { [weak self] in
            self?.moreTapHandler?()
        }
        
        if attendees.count == 0 {
            attendeeContainer.destroyHeight()
            attendeeContainerNoHeightConstriant.priority = .defaultHigh
        }else{
            attendeeContainer.restoreHeight()
            attendeeContainerNoHeightConstriant.priority = .defaultLow
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        shadowView.layer.masksToBounds = false
        shadowView.layer.shadowOpacity = 0.6
        shadowView.layer.shadowOffset = CGSize(width: 0.5, height: 1)
        attendeeContainerNoHeightConstriant.priority = .defaultLow
        
    }
    
}
