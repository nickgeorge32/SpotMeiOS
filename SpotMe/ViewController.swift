//
//  ViewController.swift
//  SpotMe
//
//  Created by Nicholas George on 3/18/17.
//  Copyright © 2017 Nicholas George. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuthUI
import FirebaseGoogleAuthUI
import FirebaseTwitterAuthUI

class ViewController: UIViewController, FUIAuthDelegate {
    //MARK: Outlets and Variables
    fileprivate(set) var auth:Auth?
    fileprivate(set) var authUI: FUIAuth? //only set internally but get externally
    fileprivate(set) var authStateListenerHandle: AuthStateDidChangeListenerHandle?
    var user: User?
    var ref: DocumentReference!
    
    @IBAction func authButton(_ sender: Any) {
        // Present the default login view controller provided by authUI
        let authViewController = authUI?.authViewController();
        self.present(authViewController!, animated: true, completion: nil)
    }
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.auth = Auth.auth()
        self.authUI = FUIAuth.defaultAuthUI()
        self.authUI?.delegate = self
        self.authUI?.providers = [FUIGoogleAuth(), FUITwitterAuth()]
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        displayAlert(title: "Beta Test", message: "Data may be erased periodically during the testing period. If you find that your account has been removed, simply signup again.")
    }
    
    func authUI(_ authUI: FUIAuth, didSignInWith user: User?, error: Error?) {
        if user != nil {
            loadProfile()
        }
        
        guard let authError = error else { return }
        
        let errorCode = UInt((authError as NSError).code)
        
        switch errorCode {
        case FUIAuthErrorCode.userCancelledSignIn.rawValue:
            print("User cancelled sign-in");
            break
            
        default:
            let detailedError = (authError as NSError).userInfo[NSUnderlyingErrorKey] ?? authError
            print("Login error: \((detailedError as! NSError).localizedDescription)");
        }
    }
    
    //MARK: Load Profile
    func loadProfile() {
        ref = Firestore.firestore().collection("users").document((user?.email)!)
        ref.getDocument(completion: { (userDoc, error) in
            if let document = userDoc {
                if document.exists {
                    print("Document data: \(document.data())")
                    self.performSegue(withIdentifier: "homeSegue", sender: nil)
                } else {
                    print("Document does not exist")
                    self.ref = Firestore.firestore().collection("trainers").document((self.user?.email)!)
                    self.ref.getDocument(completion: { (trainerDoc, error) in
                        if let document = trainerDoc {
                            if document.exists {
                                print("Document data: \(document.data())")
                                self.performSegue(withIdentifier: "homeSegue", sender: nil)
                            } else {
                                print("Document does not exist")
                                self.performSegue(withIdentifier: "accountTypeSegue", sender: nil)
                            }
                        }
                    })
                }
            }
        })
    }
    
    //MARK: Display Alert
    func displayAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
            UIAlertAction in
            self.authStateListenerHandle = self.auth?.addStateDidChangeListener { (auth, user) in
                if let activeUser = user {
                    if self.user != activeUser {
                        self.user = activeUser
                        self.loadProfile()
                    }
                } else {
                    self.authButton(self)
                }
            }
            
        }
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
}
