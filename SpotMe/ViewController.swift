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
    fileprivate(set) var auth:Auth?
    fileprivate(set) var authUI: FUIAuth? //only set internally but get externally
    fileprivate(set) var authStateListenerHandle: AuthStateDidChangeListenerHandle?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.auth = Auth.auth()
        self.authUI = FUIAuth.defaultAuthUI()
        self.authUI?.delegate = self
        self.authUI?.providers = [FUIGoogleAuth(), FUITwitterAuth()]
        
        
        self.authStateListenerHandle = self.auth?.addStateDidChangeListener { (auth, user) in
            guard user != nil else {
                //self.authButton(self)
                self.performSegue(withIdentifier: "homeSegue", sender: nil)
                return
            }
        }
    }
    
    @IBAction func authButton(_ sender: Any) {
        // Present the default login view controller provided by authUI
        let authViewController = authUI?.authViewController();
        self.present(authViewController!, animated: true, completion: nil)
    }
    
    
    func authUI(_ authUI: FUIAuth, didSignInWith user: User?, error: Error?) {
        if user != nil {
            performSegue(withIdentifier: "accountTypeSegue", sender: nil)
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
    
    
    override func viewDidAppear(_ animated: Bool) {
        displayAlert(title: "Beta Test", message: "Data may be erased periodically during the testing period. If you find that your account has been removed, simply signup again.")
    }
    
    func displayAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
            UIAlertAction in
        }
        alertController.addAction(okAction)
        //alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
}
