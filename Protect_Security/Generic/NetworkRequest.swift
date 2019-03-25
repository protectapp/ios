//
//  NetworkReqeust.swift
//  Protect_Security
//
//  Created by Jatin Garg on 24/12/18.
//  Copyright © 2018 Jatin Garg. All rights reserved.
//
//#MARK: Network request does the work of Api calling and response callback

import Foundation

protocol NetworkRequest {
    associatedtype T: Decodable
    var method: RequestType { get }
    var path: String { get }
    var params: [String:Any] { get }
}

extension NetworkRequest {
    
    func fire(_ completionBlock: @escaping (_ response: T?, _ error: Error?) -> Void) {
        RequestHandler.shared.makeRequest(with: URL(string: APIConfig.baseURL + path), using: params, of: method) { (response) in
         //   print(response)
            
            if response.status == false {
                completionBlock(nil,CustomError(title: nil , code: 101, description: response.message))
            } else if let data = response.data{
                do {
                    let responseData = try JSONSerialization.data(withJSONObject: data, options: [])
                    do {
                        let model = try JSONDecoder().decode(T.self, from: responseData)
                        completionBlock(model, nil)
                    } catch {
                        print(error)
                        completionBlock(nil, error)
                    }
                } catch {
                    print(error)
                    completionBlock(nil, error)
                }
            } else {
                
                completionBlock(nil,NSError(domain: "Couldn't obtain any data", code: 101, userInfo: nil) )
            }
        }
    }
}
