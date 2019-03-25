//
//  CustomError.swift
//  Rework
//
//  Created by Jatin Garg on 9/28/18.
//  Copyright © 2018 New Media guru. All rights reserved.
//

import Foundation

protocol CustomErrorProtol: LocalizedError{
    var title: String?{ get }
    var code: Int { get }
}

struct CustomError: CustomErrorProtol{
    var title: String?
    var code: Int
    var errorDescription: String? { return _description }
    var failureReason: String? { return _description }
    
    private var _description: String
    
    init(title: String?, code: Int, description: String){
        self.title = title ?? "Error"
        self._description = description
        self.code = code
    }
}
