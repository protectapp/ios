//
//  ResponseModel.swift
//  Protect_Security
//
//  Created by Jatin Garg on 22/12/18.
//  Copyright © 2018 Jatin Garg. All rights reserved.
//

import Foundation
struct ResponseModel {
    
    let status: Bool
    let message: String
    let data: Any?
    
    init(status: Bool, message: String, data: Any?){
        self.status = status
        self.message = message
        self.data = data
    }
    
    var dataDictionary: [String:Any]?{
        guard let dict = data as? [String:Any] else { return nil }
        return dict
    }
    
    var dataArray: [[String:Any]]?{
        guard let arr = data as? [[String:Any]] else
        {
            return nil
        }
        return arr
    }
    
    var dataString: String?{
        let data = try! JSONSerialization.data(withJSONObject: self.data!, options: .prettyPrinted)
        let string = String(data: data, encoding: .utf8)
        return string
    }
}
