//
//  ChatMessageModel.swift
//  Protect_Security
//
//  Created by Jatin Garg on 22/12/18.
//  Copyright © 2018 Jatin Garg. All rights reserved.
//

import Foundation

struct ChatMessageModel: Encodable, Decodable {
    let snapshotID: String
    let chatDate: String?
    let chatTime: String?
    let senderID: Int
    let chatMessage: String
    let senderName: String
    
    static let dateFormat: String = "yyyy-MM-dd"
    static let timeFormat: String = "HH:mm"
    static let twelveHourFormat: String = "hh:mm a"
    
    var timeStampString: String? {
        //conver the time to 12 hour format
        guard chatTime != nil, chatDate != nil else { return nil }
        let temp = System.getDate(from: chatTime!, usingformat: ChatMessageModel.twelveHourFormat)
        guard let twelveHrFormat = System.getString(fromDate: temp, usingFormat: "hh:mm a") else {
            return nil
        }
        let string = chatDate! + " " + twelveHrFormat
        return string
    }
    
    var formattedChatDate: String?{
        guard chatDate != nil else { return nil }
        let currentFormat = ChatMessageModel.dateFormat
        let targetFormat = "MMM d, yyyy"
        guard let date = System.getDate(from: chatDate!, usingformat: currentFormat) else { return nil }
        return System.getString(fromDate: date, usingFormat: targetFormat)
    }
    
    var chatTimestampConvertedToDate: Date? {
        guard chatDate != nil, chatTime != nil else {
            return nil
        }
        let timestampformat = ChatMessageModel.dateFormat + " " + ChatMessageModel.twelveHourFormat
        return System.getDate(from: chatDate! + " " + chatTime!, usingformat: timestampformat)
    }
    
    var timeElapsedString: String? {
        guard chatTimestampConvertedToDate != nil, chatTime != nil else {
            return nil
        }
        return chatTimestampConvertedToDate!.getElapsedInterval() + ", \(chatTime!)"
    }
    
    private enum CodingKeys: String, CodingKey {
        case snapshotID
        case chatDate
        case chatTime
        case senderID
        case chatMessage
        case senderName
    }
}
