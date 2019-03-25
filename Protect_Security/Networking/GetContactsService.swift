//
//  GetContactsService.swift
//  Protect_Security
//
//  Created by Harish Chandra Singh on 04/01/2019.
//  Copyright © 2019 Jatin Garg. All rights reserved.
//
//#MARK: Get list of security members for the particular organization 

import Foundation

class GetContactsService: NetworkRequest {
    
    let page: Int?
    let isRecent:Bool?
    
    init(page:Int, isRecent: Bool) {
        self.page = page
        self.isRecent = isRecent
    }
    
    typealias T = GetUserContactsModel
    
    var path: String {
        
        let path = isRecent! ? APIConfig.getRecentChat :
        ((APIConfig.getContacts + (page?.description)!))
        return path
    }
    
    var method: RequestType {
        return .get
    }
    var params: [String : Any] {
        return [:]
    }
}
