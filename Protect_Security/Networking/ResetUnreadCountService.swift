//
//  ResetUnreadCountService.swift
//  Protect_Security
//
//  Created by Harish Chandra Singh on 16/01/2019.
//  Copyright © 2019 Jatin Garg. All rights reserved.
//
//#MARK: Reset unread notification count

import Foundation

class ResetUnreadCountService: NetworkRequest {
    
    private let receiverId: Int
 
    init(receiverId: Int) {
        self.receiverId = receiverId
    }
    
    typealias T = ResetMessageModel
    
    var path: String {
        return APIConfig.resetUnreadCount
    }
    var method: RequestType {
        return .post
    }
    var params: [String : Any] {
        return ["receiverID": receiverId]
    }
}
