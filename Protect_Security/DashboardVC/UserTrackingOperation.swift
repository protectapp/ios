//
//  UserTrackingOperation.swift
//  Protect_Security
//
//  Created by Jatin Garg on 08/01/19.
//  Copyright © 2019 Jatin Garg. All rights reserved.
//

import Foundation

class UserTrackingOperation: AsynchronousOperation {
    private let minorID: NSNumber
    private let majorID: NSNumber
    
    public var userLocation: LocationResponseModel?
    public var error: Error?
    
    private let session = URLSession(configuration: .default)
    private let url = URL(string: APIConfig.baseURL + APIConfig.trackUser)
    private var postParams: [String:Any] {
        return [
            "majorID" : majorID,
            "minorID" : minorID
        ]
    }
    private var authToken: String? {
        return UserPreferences.userToken
    }
    
    init(minorID: NSNumber, majorID: NSNumber) {
        self.minorID = minorID
        self.majorID = majorID
    }
    
    override func main() {
        super.main()
        
        guard let token = authToken else {
            error = NSError(domain: "Session expired", code: 101, userInfo: nil)
            state = .finished
            return
        }
        
        var request = URLRequest(url: url!)
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.setValue(token, forHTTPHeaderField: "token")
        request.httpMethod = "POST"
        let jsonData = try! JSONSerialization.data(withJSONObject: postParams, options: .prettyPrinted)
        request.httpBody = jsonData
        
        let task = session.dataTask(with: request) { (data, response, error) in
            defer {
                self.state = .finished
            }
            let header = ((response as? HTTPURLResponse)?.allHeaderFields as? Dictionary<String,String>)
            if RequestHandler.shared.hasSessionTimedout(headers: header) {
                RequestHandler.shared.redirectToAuth()
            }else{
                if error != nil {
                    self.error = error
                    return
                }
                
                guard let responseData = data else {
                    self.error = CustomError(title: nil , code: 102, description: "No data available")
                    return
                }
                do {
                    let json = (try JSONSerialization.jsonObject(with: responseData, options: .mutableContainers)) as? [String:Any]
                    
                    if json == nil {
                        self.error = CustomError(title: nil , code: 103, description: "Invalid data")
                        return
                    }
                    guard
                        let status = json!["success"] as? Bool,
                        let message = json!["message"] as? String,
                        json!["data"] != nil
                        else{
                            self.error = CustomError(title: nil , code: 103, description: "Invalid data")
                            return
                    }
                    
                    if !status {
                        self.error = CustomError(title: nil , code: 104, description: message)
                        return
                    }
                    
                    let data = json!["data"]!
                    
                    let jsonData = try JSONSerialization.data(withJSONObject: data, options: [])
                    do {
                        let castedModel = try JSONDecoder().decode(LocationResponseModel.self, from: jsonData)
                        self.userLocation = castedModel
                    } catch  {
                        print(error.localizedDescription)
                    }
                    
                } catch {
                    self.error = error
                    
                }
            }
        }
        task.resume()
    }
    
    override func cancel() {
        super.cancel()
        session.invalidateAndCancel()
        state = .finished
    }
}
