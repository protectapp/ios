//
//  ChatCellSizeCalculator.swift
//  Protect_Security
//
//  Created by Jatin Garg on 24/12/18.
//  Copyright © 2018 Jatin Garg. All rights reserved.
//

//#MARK: Chat Bubble size calcualtion logic

import UIKit

class ChatCellSizeCalculator {
    public var previousMessage: ChatMessageModel?
    public var chatMessage: ChatMessageModel!
    public var messageFont: UIFont!
    public var timeFont: UIFont!
    public var timeMessageVerticalMargin: CGFloat = 0
    public var timeContainerVerticalMargin: CGFloat = 0
    public var messageContainerVerticalMargin: CGFloat = 0
    
    private let lineSpacingForGroupedMessages: CGFloat = 5
    private let lineSpacing: CGFloat = 10
    
    public var cellSize: CGSize {
        let maxWidth: CGFloat = UIScreen.main.bounds.width * 0.65
        let baseMessageHeight = chatMessage.chatMessage.height(withConstrainedWidth: maxWidth, font: messageFont)
        let timeHeight = chatMessage.timeElapsedString?.height(withConstrainedWidth: maxWidth, font: timeFont) ?? 0
        let messageWidth = chatMessage.chatMessage.width(withConstrainedHeight: baseMessageHeight, font: messageFont)
        let timeWidth = chatMessage.timeStampString?.width(withConstrainedHeight: timeHeight, font: timeFont) ?? 0
        
        let totalWidth = max(min(messageWidth, maxWidth), timeWidth) + 16
        let totalHeight = baseMessageHeight + timeHeight + timeMessageVerticalMargin + timeContainerVerticalMargin + messageContainerVerticalMargin + verticalInsetToAdd
        return CGSize(width: totalWidth, height: totalHeight)
    }
    
    public var verticalInsetToAdd: CGFloat {
        if previousMessage == nil {
            return lineSpacing
        }else{
            //check if sender of previous message is same as that of current message
            let currentSender = chatMessage.senderID
            let previousSender = previousMessage!.senderID
            
            return currentSender == previousSender ? lineSpacingForGroupedMessages : lineSpacing
        }
    }
}
