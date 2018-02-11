//
//  AuthService.swift
//  SpotMe
//
//  Created by Nick George on 1/17/18.
//  Copyright © 2018 Nicholas George. All rights reserved.
//

import Foundation
import Firebase

class AuthService {
    static let instance = AuthService()
    
    func registerUser(fullName: String, withUsername username: String, withEmail email: String, andPassword password: String, userCreationComplete: @escaping (_ status: Bool, _ error: Error?) -> ()) {
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            if error == nil{
                userCreationComplete(true, nil)
            } else {
                userCreationComplete(false, error?.localizedDescription as! Error)
            }
        }
    }
    
    func loginUser(withEmail email: String, andPassword password: String, loginComplete: @escaping (_ status: Bool, _ error: Error?) -> ()) {
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if error != nil {
                loginComplete(false, error?.localizedDescription as! Error)
                return
            }
            loginComplete(true, nil)
        }
    }
}
