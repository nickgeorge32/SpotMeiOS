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
    
    private var _REF_BASE = DB_BASE
    private var _REF_USERS = DB_BASE.child("users")
    private var ref: DocumentReference? = nil
    
    var REF_BASE: DatabaseReference {
        return _REF_BASE
    }
    
    var REF_USERS: DatabaseReference {
        return _REF_USERS
    }
    
    func createDBUser(username: String, userData: Dictionary<String, Any>) {
        REF_USERS.child(username).updateChildValues(userData)
        ref = FIRESTORE_DB_USERS.document(username)
        ref?.setData(userData)
//        ref = FIRESTORE_DB_USERS.addDocument(data: userData) {
//            err in
//            if let err = err {
//                print("Error adding document: \(err)")
//            } else {
//                print("Document added with ID: \(self.ref!.documentID)")
//            }
//        }
    }
    
    func checkUsernameAvailability(username: String, checked: @escaping (_ success: Bool, _ error: Error?) -> ()) {
        let docRef = FIRESTORE_DB_USERS.document(username)
        docRef.getDocument { (document, error) in
            if let document = document {
                print("Document exists: \(String(describing: document.data()))")
                checked(true, nil)
            } else if error != nil {
                checked(false, error)
            } else {
                print("does not exist")
            }
        }
    }
}
