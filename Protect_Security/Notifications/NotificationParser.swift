//
//  NotificationHandler.swift
//  Protect_Security
//
//  Created by Jatin Garg on 15/01/19.
//  Copyright © 2019 Jatin Garg. All rights reserved.
//

import Foundation
import UserNotifications

class NotificationParser {
    private let rawPayload: [AnyHashable : Any]
    private let dataKey: String = "data"
    private let payloadKey: String = "payload"
    
    init(rawPayload: [AnyHashable : Any]) {
        self.rawPayload = rawPayload
    }
    
    public func getNotificationPayload<T: Decodable> (usingModelClass modelClass: T.Type) -> NotificationPayloadModel<T>? {
        let notificationPayload = rawPayload
        do{
        guard
            let jsonString = notificationPayload[dataKey] as? String,
            var jsonDictionary = try? getDictionary(fromString: jsonString)
            else {
                return nil
        }
        
        if let notificationPayloadString = jsonDictionary[payloadKey] as? String {
            let payloadDictionary = try getDictionary(fromString: notificationPayloadString)
            jsonDictionary[payloadKey] = payloadDictionary
        }
        
            let jsonData = try JSONSerialization.data(withJSONObject: jsonDictionary, options: [])
            let parsedModel = try JSONDecoder().decode(NotificationPayloadModel<T>.self, from: jsonData)
            return parsedModel
    } catch {
            print("Error parsing notification content: \(error)")
            return nil
        }
    }
    
    private func getDictionary(fromString string: String) throws -> [String:Any] {
        if let data = string.data(using: .utf8) {
            do {
                let jsonObject = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any]
                if jsonObject == nil {
                    throw NSError(domain: "Payload couldn't be typecasted to dictionary", code: 101, userInfo: nil)
                }else{
                    return jsonObject!
                }
            }catch {
                throw error
            }
        }else{
            throw NSError(domain: "Unable to obtain data out of string", code: 101, userInfo: nil)
        }
    }
}
