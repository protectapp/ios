//
//  ChatsTVC.swift
//  Protect_Security
//
//  Created by Jatin Garg on 22/12/18.
//  Copyright © 2018 Jatin Garg. All rights reserved.
//

import UIKit
import SDWebImage

class ChatsTVC: UITableViewCell {
    
    @IBOutlet weak var separatorView: UIView!
    @IBOutlet weak var unreadCountLabel: UILabel!
    @IBOutlet weak var unreadCountView: UIView!
    @IBOutlet weak var lastMessage: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var lblTimeStamp: UILabel!
    
    private var lastMessageDefaultColor: UIColor!
    private var userPlaceholder: UIImage!
    
    public var item: ChatContactModel! {
        didSet{
            configureCell()
        }
    }
    
    private func configureCell() {
        resetCell()
        if let profileImage = item.profileImageURL {
            userImage.sd_setImage(with: URL(string: profileImage), placeholderImage: userPlaceholder)
        }
        nameLabel.text = item.name

        if item.unreadMessages != 0 {
            unreadCountLabel.text = "\(item.unreadMessages ?? 0)"
            unreadCountView.isHidden = false
        }
        unreadCountView.isHidden = true
        lblTimeStamp.isHidden = true
    }

    private func resetCell() {
        unreadCountView.isHidden = true
        lastMessage.text = nil
        lastMessage.textColor = lastMessageDefaultColor
        nameLabel.text = nil
        unreadCountLabel.text = "0"
        userImage.image = userPlaceholder
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        lastMessageDefaultColor = lastMessage.textColor
        userPlaceholder = userImage.image
        unreadCountView.layer.shadowOpacity = 0.5
        unreadCountView.layer.shadowOffset = .zero
    }
}
