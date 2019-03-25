//
//  AttendeeContainer.swift
//  Protect_Security
//
//  Created by Jatin Garg on 27/12/18.
//  Copyright © 2018 Jatin Garg. All rights reserved.
//

import UIKit

enum AttendeeContainerMode {
    case expanded, collapsed
}
class AttendeeContainer: View {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var modeToggleButton: UIButton!
    @IBOutlet weak var labelContainerMargin: NSLayoutConstraint!
    @IBOutlet weak var attendeeLabel: UILabel!
    
    private let maxAttendeesToload = 5
    private let attendeeSize: CGFloat = 30
    
    public var containerMode: AttendeeContainerMode = .collapsed
    public var attendees: [Usermodel] = [] {
        didSet{
            loadAttendees()
        }
    }
    
    
    public var moreTappedHandler: ( () -> () )?
    
    private var attendeeViews: [AttendeeView] {
        return containerView.subviews.filter( {
            return $0 as? AttendeeView != nil
        }) as! [AttendeeView]
    }
    
    override func setup() {
        super.setup()
        let nib = Bundle.main.loadNibNamed("AttendeeContainer", owner: self, options: nil)?.first as! UIView
        nib.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        nib.frame = bounds
        addSubview(nib)
    }
    
    private func loadAttendees() {
        containerView.subviews.forEach {
            $0.removeFromSuperview()
        }
        
        let attendeesToLoad = (attendees.count > maxAttendeesToload) && (containerMode == .collapsed) ? Array(attendees[0..<maxAttendeesToload]) : attendees
        
        var index = 0
        for attendee in attendeesToLoad {
            let newAttendeeView = AttendeeView()
            newAttendeeView.attendee = attendee
            newAttendeeView.toggleOverlay(false)
            containerView.addSubview(newAttendeeView)
            if containerMode == .expanded {
                newAttendeeView.expand()
                
                if index == 0 {
                    newAttendeeView.anchor(toView: containerView, myHorizontalEdge: .left, viewHorizontalEdge: .left, shouldUseSafeAreaHorizontally: false, horizontalOffset: 0, myVerticalEdge: .top, viewVerticalEdge: .top, shouldUseSafeAreaVertically: false, verticalOffset: 0)
                    newAttendeeView.anchor(toView: containerView, myHorizontalEdge: .right, viewHorizontalEdge: .right, shouldUseSafeAreaHorizontally: false, horizontalOffset: 0, myVerticalEdge: nil, viewVerticalEdge: nil, shouldUseSafeAreaVertically: false, verticalOffset: 0)
                }else{
                    let previousView = attendeeViews[index - 1]
                    newAttendeeView.anchor(toView: previousView, myHorizontalEdge: .left, viewHorizontalEdge: .left, shouldUseSafeAreaHorizontally: false, horizontalOffset: 0, myVerticalEdge: .top, viewVerticalEdge: .bottom, shouldUseSafeAreaVertically: false, verticalOffset: 0)
                    newAttendeeView.anchor(toView: previousView, myHorizontalEdge: .right, viewHorizontalEdge: .right, shouldUseSafeAreaHorizontally: false, horizontalOffset: 0, myVerticalEdge: nil, viewVerticalEdge: nil, shouldUseSafeAreaVertically: false, verticalOffset: 0)
                }
                
                if index == attendeesToLoad.count - 1 {
                    newAttendeeView.anchor(toView: containerView, myHorizontalEdge: nil, viewHorizontalEdge: nil, shouldUseSafeAreaHorizontally: false, horizontalOffset: 0, myVerticalEdge: .bottom, viewVerticalEdge: .bottom, shouldUseSafeAreaVertically: false, verticalOffset: -10)
                }
            }else{
                newAttendeeView.collapse()
                if index == 0 {
                    newAttendeeView.anchor(toView: containerView, myHorizontalEdge: .left, viewHorizontalEdge: .left, shouldUseSafeAreaHorizontally: false, horizontalOffset: 0, myVerticalEdge: .top, viewVerticalEdge: .top, shouldUseSafeAreaVertically: false, verticalOffset: 0)
                    newAttendeeView.anchor(toView: containerView, myHorizontalEdge: nil, viewHorizontalEdge: nil, shouldUseSafeAreaHorizontally: false, horizontalOffset: 0, myVerticalEdge: .bottom, viewVerticalEdge: .bottom, shouldUseSafeAreaVertically: false, verticalOffset: -10)
                }else{
                    let previousView = attendeeViews[index - 1]
                    newAttendeeView.anchor(toView: previousView, myHorizontalEdge: .left, viewHorizontalEdge: .right, shouldUseSafeAreaHorizontally: false, horizontalOffset: -attendeeSize/2, myVerticalEdge: nil, viewVerticalEdge: nil, shouldUseSafeAreaVertically: false, verticalOffset: 0)
                    newAttendeeView.setCenter(withRespectTo: previousView, axis: .vertical)
                }
                if index == attendeesToLoad.count - 1 {
                    let remainingAttendees = attendees.count - attendeesToLoad.count
                    if remainingAttendees > 0 {
                        let remainingText = "+\(remainingAttendees)"
                        newAttendeeView.toggleOverlay(true)
                        newAttendeeView.setInfo(remainingText)
                    }
                }
            }
            
            
            newAttendeeView.fixHeight(to: attendeeSize)
            newAttendeeView.setCornerRadius((attendeeSize-2)/2)
            newAttendeeView.layer.masksToBounds = true
            newAttendeeView.layer.cornerRadius = attendeeSize/2
            
            index += 1
        }
        modeToggleButton.setTitle(containerMode == .collapsed ? "More+" : "Less-", for: .normal)
    }
    
    @IBAction func moreButtonTapped(_ sender: UIButton) {
        moreTappedHandler?()
    }
    
    public func destroyHeight() {
        labelContainerMargin.constant = 0
        attendeeLabel.text = nil
    }
    
    public func restoreHeight() {
        labelContainerMargin.constant = 5
        attendeeLabel.text = "Attendee"
    }
}
