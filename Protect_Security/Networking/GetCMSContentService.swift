//
//  GetCMSContentService.swift
//  Protect_Security
//
//  Created by Harish Chandra Singh on 27/12/2018.
//  Copyright © 2018 Jatin Garg. All rights reserved.
//
//#MARK: Get Static contents

import Foundation

enum CMSContentType: String {
    case aboutUs = "About us"
    case privacyPolicy = "Privacy policy"
}

class GetCMSContentService: NetworkRequest {
    
    private let contentType: CMSContentType
    
    init(contentType: CMSContentType) {
        self.contentType = contentType
    }
    
    typealias T = GetCMSContent
    
    var path: String {
        return APIConfig.getCMSContent
    }
    
    var method: RequestType {
        return .get
    }
    var params: [String : Any] {
        return ["contentType": contentType.rawValue ]
    }
}
