//
//  UserPreferences.swift
//  Protect_Security
//
//  Created by Jatin Garg on 24/12/18.
//  Copyright © 2018 Jatin Garg. All rights reserved.
//

import Foundation

struct UserPreferences {
    static var userDetails: Usermodel? {
        get {
            guard let userData = UserDefaults.standard.value(forKey: "user") as? Data else {
                return nil
            }
            do {
                return try JSONDecoder().decode(Usermodel.self, from: userData)
            }catch {
                print("failed to get user details: \(error)")
                return nil
            }
        }set{
            if newValue != nil {
                do {
                    let jsonObject = try JSONEncoder().encode(newValue!)
                    UserDefaults.standard.set(jsonObject, forKey: "user")
                }catch {
                    print("Failed to save user details: \(error)")
                }
            }else{
                UserDefaults.standard.set(nil, forKey: "user")
            }
        }
    }
    
    static var userToken: String? {
        get{
            return UserDefaults.standard.value(forKey: "token") as? String
        }set{
            UserDefaults.standard.set(newValue, forKey: "token")
        }
    }
    
    static var uuid: String? {
        get{
            return UserDefaults.standard.value(forKey: "uuid") as? String
        }set{
            UserDefaults.standard.set(newValue, forKey: "uuid")
        }
    }
    
    static var deviceToken: String? {
        get{
            return UserDefaults.standard.value(forKey: "deviceToken") as? String
        }set{
            UserDefaults.standard.set(newValue, forKey: "deviceToken")
        }
    }
}
