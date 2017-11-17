//
//  AuthenticationHelper.swift
//  SpotMe
//
//  Created by Nick George on 11/16/17.
//  Copyright © 2017 Nicholas George. All rights reserved.
//

import Foundation
import Firebase

//class AuthenticationHelper {
//    func createNewUser(withEmail: email, password: password) {
//        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
//            <#code#>
//        }
//    }
//    
//    //MARK: Load Profile
//    func loadProfile() {
//        ref = Firestore.firestore().collection("users").document((user?.email)!)
//        ref.getDocument(completion: { (userDoc, error) in
//            if let document = userDoc {
//                if document.exists {
//                    print("Document data: \(document.data())")
//                    self.performSegue(withIdentifier: "homeSegue", sender: nil)
//                } else {
//                    print("Document does not exist")
//                    self.ref = Firestore.firestore().collection("trainers").document((self.user?.email)!)
//                    self.ref.getDocument(completion: { (trainerDoc, error) in
//                        if let document = trainerDoc {
//                            if document.exists {
//                                print("Document data: \(document.data())")
//                                self.performSegue(withIdentifier: "homeSegue", sender: nil)
//                            } else {
//                                print("Document does not exist")
//                                self.performSegue(withIdentifier: "accountTypeSegue", sender: nil)
//                            }
//                        }
//                    })
//                }
//            }
//        })
//    }
//}

