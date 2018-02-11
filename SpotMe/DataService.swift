//
//  DataService.swift
//  SpotMe
//
//  Created by Nick George on 1/17/18.
//  Copyright © 2018 Nicholas George. All rights reserved.
//

import Foundation
import Firebase

class DataService {
    static let instance = DataService()
    
    private var ref: DocumentReference? = nil
    
    func createDBUser(username: String, userData: Dictionary<String, Any>) {
        ref = FIRESTORE_DB_USERS.document(username)
        ref?.setData(userData)
        
    }
    
    func checkUsernameAvailability(username: String, available: @escaping (_ success: Bool, _ error: Error?) -> ()) {
        let docRef = FIRESTORE_DB_USERS.document(username)
        docRef.getDocument { (document, error) in
            if let document = document {
                if document.exists {
                    print("Document exists: \(String(describing: document.data()))")
                    available(false, nil)
                } else {
                    print("does not exist")
                    available(true, nil)
                }
            } else if error != nil {
                available(false, error)
            }
        }
    }
    
    func isProfileComplete() {
        
    }
}
