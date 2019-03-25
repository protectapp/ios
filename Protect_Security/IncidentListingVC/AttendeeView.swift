//
//  AttendeeView.swift
//  Protect_Security
//
//  Created by Jatin Garg on 27/12/18.
//  Copyright © 2018 Jatin Garg. All rights reserved.
//

import UIKit

class AttendeeView: View {
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var overlayView: UIView!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var nameLabelImageInset: NSLayoutConstraint!
    
    public var attendee: Usermodel! {
        didSet{
            profileImage.sd_setImage(with: URL(string: attendee.profileImageURL ?? ""), placeholderImage: UIImage(named: "chat_placeholder")!)
            usernameLabel.text = attendee.name
        }
    }
    
    public func expand() {
        usernameLabel.text = attendee.name
        nameLabelImageInset.constant = 10
    }
    
    public func collapse() {
        usernameLabel.text = nil
        nameLabelImageInset.constant = 2
    }
    
    public func setCornerRadius(_ radius: CGFloat) {
        profileImage.layer.cornerRadius = radius
        overlayView.layer.cornerRadius = radius
    }
    
    public func toggleOverlay(_ shouldshow: Bool) {
        overlayView.isHidden = !shouldshow
    }
    
    public func setInfo(_ info: String) {
        infoLabel.text = info
    }
    
    
    override func setup() {
        super.setup()
        let nib = Bundle.main.loadNibNamed("AttendeeView", owner: self, options: nil)?.first as! UIView
        nib.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        nib.frame = bounds
        addSubview(nib)
    }
}
