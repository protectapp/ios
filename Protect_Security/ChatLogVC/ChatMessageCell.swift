//
//  ChatMessageCell.swift
//  Protect_Security
//
//  Created by Jatin Garg on 22/12/18.
//  Copyright © 2018 Jatin Garg. All rights reserved.
//

import UIKit

class ChatMessageCell: UICollectionViewCell {
    @IBOutlet weak var bubbleView: BubbleView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var textView: UILabel!
    
    @IBOutlet weak var bubbleWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var messageWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var bubbleLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var bubbleTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var bubbleTopConstraint: NSLayoutConstraint!
    
    public var chatMessage: ChatMessageModel! {
        didSet{
            resetCell()
            configureCell()
        }
    }
    
    public var width: CGFloat = 0 {
        didSet{
            bubbleWidthConstraint.priority = .defaultHigh
            bubbleWidthConstraint.constant = width
            messageWidthConstraint.constant = width - 16
        }
    }
    
    public var previousSenderID: Int?
    private let cornerRadius: CGFloat = 8
    
    private func resetCell(){
        let senderID = chatMessage.senderID
        guard let userDetails = UserPreferences.userDetails else {
            fatalError("Unable to get users details from cache")
        }
        let isSender = senderID == userDetails.id
        let constraintToEnable = isSender ? bubbleTrailingConstraint : bubbleLeadingConstraint
        let constraintToDisable = isSender ? bubbleLeadingConstraint : bubbleTrailingConstraint
        
        constraintToEnable?.priority = .defaultHigh
        constraintToDisable?.priority = .defaultLow
        bubbleWidthConstraint.priority = .defaultLow
        
        bubbleView.backgroundColor = isSender ? Color.accentColor : UIColor.white
        textView.textColor = isSender ? UIColor.white : Color.textColor
        timeLabel.textColor = textView.textColor.withAlphaComponent(0.7)
        
        let roundedEdges: UIRectCorner = isSender ? [.topLeft, .topRight,.bottomLeft] : [.topLeft, .topRight,.bottomRight]
        bubbleView.roundCorners(corners: roundedEdges , radius: 8)
    }
    
    private func configureCell() {
        textView.text = chatMessage.chatMessage
        timeLabel.text = chatMessage.timeElapsedString
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        bubbleView.layer.masksToBounds = true
        textView.setContentHuggingPriority(.defaultLow, for: .vertical)
        textView.setContentHuggingPriority(.defaultLow, for: .horizontal)
    }
}
