//
//  ViewController.swift
//  SpotMe
//
//  Created by Nicholas George on 3/18/17.
//  Copyright © 2017 Nicholas George. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController {
    @IBOutlet var usernameField: UITextField!
    @IBOutlet var passwordField: UITextField!
    @IBOutlet var signUpOrLoginButton: UIButton!
    @IBOutlet var changeModeButton: UIButton!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    var authMode = true
    var isTrainer:Bool!
    var token = ""
    
    var dbRef:DatabaseReference!

    override func viewDidLoad() {
        super.viewDidLoad()
        dbRef = Database.database().reference()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        displayAlert(title: "Beta Test", message: "Data may be erased periodically during the testing period. If you find that your account has been removed, simply signup again.")
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        token = appDelegate.token
    }

    
    func displayAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
//        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
//            UIAlertAction in self.redirectUser()
//        }
//        alertController.addAction(okAction)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func signUpOrLogin(_ sender: Any) {
        self.activityIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
        if usernameField.text == "" && passwordField.text == "" {
            displayAlert(title: "Invalid Values", message: "Please ensure all fields are filled in properly")
            UIApplication.shared.endIgnoringInteractionEvents()
        } else {
            if let email = usernameField.text {
                if let password = passwordField.text {
                    if authMode {
                        Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
                            if error != nil {
                                self.displayAlert(title: "Sign Up Error", message: error!.localizedDescription)
                            } else {
                                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
                                self.dbRef.child("users").child((user?.uid)!).setValue(["email":email])
                                    self.dbRef.child("users").child((user?.uid)!).updateChildValues(["fcm-reg":self.token])
                                    self.activityIndicator.stopAnimating()
                                    UIApplication.shared.endIgnoringInteractionEvents()
                                    self.performSegue(withIdentifier: "accountTypeSegue", sender: nil)
                                }
                            }
                        })
                    } else {
                        Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
                            if error != nil {
                                self .displayAlert(title: "Login Error", message: error!.localizedDescription)
                            } else {
                                //self.redirectUser()
                                self.performSegue(withIdentifier: "segueHomeFromLogin", sender: nil)
                            }
                        })
                    }
                }
            }
        }
    }
    
    @IBAction func changeMode(_ sender: Any) {
        if authMode {
            authMode = false
            signUpOrLoginButton.setTitle("Login", for: .normal)
            changeModeButton.setTitle("Sign Up", for: .normal)
        } else {
            authMode = true
            signUpOrLoginButton.setTitle("Sign Up", for: .normal)
            changeModeButton.setTitle("Login", for: .normal)
        }
    }
    
    func redirectUser() {
       dbRef.child("users").child((Auth.auth().currentUser?.uid)!).observeSingleEvent(of: .value, with: { (snapshot) in
        if snapshot.hasChild("isTrainer") {
            self.dbRef.child("users").child((Auth.auth().currentUser?.uid)!).child("isTrainer").observeSingleEvent(of: .value, with: { (snapshot) in
                self.isTrainer = snapshot.value as! Bool
                if self.isTrainer {
                    print("is trainer")
                } else {
                    print("not trainer")
                }
            })
        }
       })
    }
}

