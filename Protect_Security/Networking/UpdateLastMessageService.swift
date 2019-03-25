//
//  UpdateLastMessageService.swift
//  Protect_Security
//
//  Created by Harish Chandra Singh on 14/01/2019.
//  Copyright © 2019 Jatin Garg. All rights reserved.
//

//#MARK: Update last message for showing on Chats list screen

import Foundation

class UpdateLastMessageService: NetworkRequest {
    
    private let lastMessage: String
    private let receiverID: Int

    init(lastMessage: String, receiverID: Int) {
        
        self.lastMessage = lastMessage
        self.receiverID = receiverID
    }
    
    typealias T = ChatContactModel
    
    var path: String {
        return APIConfig.updateLastMessage
    }
    var method: RequestType {
        return .post
    }
    var params: [String : Any] {
        return ["lastMessage": lastMessage , "receiverID": receiverID]
    }
}
