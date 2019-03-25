//
//  FirebaseAuthService.swift
//  Protect_Security
//
//  Created by Jatin Garg on 28/12/18.
//  Copyright © 2018 Jatin Garg. All rights reserved.
//

import FirebaseAuth

class FirebaseAuthService {
    static let shared = FirebaseAuthService()
    
    typealias completionBlock = (_ error: Error?)->Void
    
    public func signIn(usingEmail email: String, password: String, completion: completionBlock?) {
        /*
            1. try signing in
            2. if error, check if due to user not found
                2.1 if yes, create user
                2.2 check for error.
                2.3 return error in completion if error
                2.4 if no error, return success in completion as firebase will auto sign in on user creation
            3. if error due to any other reason, skip user creation and return error in completion
            4. if no error, return success in completion
         */
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if error != nil {
                let firebaseError = AuthErrorCode(rawValue: error!._code)
                if firebaseError == .userNotFound {
                    //create user account
                    Auth.auth().createUser(withEmail: email, password: password, completion: { (result, error) in
                        completion?(error)
                    })
                }else{
                    completion?(error)
                }
            }else{
                completion?(nil)
            }
        }
    }
    
    public func signOut() throws {
        try Auth.auth().signOut()
    }
}

let FirAuth = FirebaseAuthService.shared
