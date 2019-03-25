//
//  RequestHandler.swift
//  Protect_Security
//
//  Created by Jatin Garg on 22/12/18.
//  Copyright © 2018 Jatin Garg. All rights reserved.
//

import UIKit

enum RequestType: String{
    case get = "GET"
    case post = "POST"
}

class RequestHandler: NSObject{
    static let shared = RequestHandler()
    let session = URLSession.shared
    
    typealias completion = (ResponseModel)->Void
    
    public func redirectToAuth(){
        DispatchQueue.main.async {
            self.flushUserPreferences()
            var vcGroup: UIViewController!
            #if Protect_Security
            vcGroup = System.constructSecurityRoot()
            #elseif Protect_User
            vcGroup = System.constructUserRoot()
            #endif
            guard
                let delegate = UIApplication.shared.delegate as? AppDelegate,
                let window = delegate.window
            else{
               return
            }
            window.rootViewController = vcGroup
        }
    }
    
    public func flushUserPreferences() {
        UserPreferences.userDetails = nil
        UserPreferences.userToken = nil
    }
    
    public func hasSessionTimedout(headers: [String:String]?) -> Bool {
        /*
         1. Check whether the headers contain a 'status' key
         2. User session has timed out when the value of status is '401'
         */
        
        let status = headers?["Status"]
        
        if status != nil && status! == "401" {
            return true
        }
        
        return false
    }
    
    
    func makeRequest(with url: URL?,using parameters: [String:Any]?,of type: RequestType,_ completion: completion?){
        
        guard  var requestURL = url else {
            let response = ResponseModel(status: false, message: "Invalid URL supplied", data: nil)
            completion?(response)
            return
        }
        
        if type == .get && parameters != nil{
            let paramString = parameters!.stringFromHttpParameters()
            if paramString != "" {
                requestURL = URL(string: requestURL.absoluteString + "?\(paramString)")!
            }
        }
        
        var request = URLRequest(url: requestURL)
        
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        
        if let accessToken = UserPreferences.userToken {
            request.setValue(accessToken, forHTTPHeaderField: "token")
        }
    
        if parameters != nil && type == .post{
            var jsonData: Data!
            request.httpMethod = "POST"
            do{
                jsonData = try JSONSerialization.data(withJSONObject: parameters!, options: .prettyPrinted)
            }catch let error{
                completion?(ResponseModel(status: false, message: error.localizedDescription, data: nil))
                return
            }
            request.httpBody = jsonData
            
        }
        if type == .get{
            request.httpMethod = "GET"
        }
        
        if let url = url?.description {
            if url.contains("user-logout"){
                flushUserPreferences()
            }
        }
        let task = session.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                
                let headers = (response as? HTTPURLResponse)?.allHeaderFields as? Dictionary<String,String>
                if self.hasSessionTimedout(headers: headers) {
                    //return some arbitrary response to keep error message from triggering
                    completion?(ResponseModel(status: true, message: "timeout", data: Dictionary<String,Any>()))
                    self.redirectToAuth()
                    return
                }
                if error != nil{
                    completion?(ResponseModel(status: false, message: error!.localizedDescription, data: nil))
                    return
                }
                
                if let status = response as? HTTPURLResponse, status.statusCode != 200 {
                    if status.statusCode == 401 {
                        completion?(ResponseModel(status: true, message: "Session expired", data: Dictionary<String,Any>()))
                         self.redirectToAuth()
                    } else {
                        // Invalid status code
                        completion?(ResponseModel(status: false, message:    "The server is not responding.”", data: nil))
                        //Oops! Something went wrong.
                    }
                    return
                }
                
                guard let responseData = data else {
                    
                    completion?(ResponseModel(status: false, message: "No Data Returned", data: nil))
                    return
                }
                
                do{
                    let json = try JSONSerialization.jsonObject(with: responseData, options: .mutableContainers)
                    guard let dict = json as? [String:Any] else{
                        completion?(ResponseModel(status: false, message: "Type casting failed", data: nil))
                        return
                    }
                    
                    guard
                        let status = dict["success"] as? Bool,
                        let message = dict["message"] as? String else {
                            completion?(ResponseModel(status: false, message: "Invalid dataformat", data: nil))
                            return
                    }
                    
                    //all went well
                    completion?(ResponseModel(status: status, message: message, data: dict["data"]))
                    
                }catch let jsonerror {
                    
                    completion?(ResponseModel(status: false, message: jsonerror.localizedDescription, data: nil))
                    return
                }
            }
        }
        task.resume()
    }
}
