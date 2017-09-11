//
//  ViewController.swift
//  SpotMe
//
//  Created by Nicholas George on 3/18/17.
//  Copyright © 2017 Nicholas George. All rights reserved.
//

import UIKit
import Parse
import Firebase

class ViewController: UIViewController {
    @IBOutlet var usernameField: UITextField!
    @IBOutlet var passwordField: UITextField!
    @IBOutlet var signUpOrLoginButton: UIButton!
    @IBOutlet var changeModeButton: UIButton!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    var authMode = true
    var isTrainer:Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        displayAlert(title: "Beta Test", message: "Data may be erased periodically during the testing period. If you find that your account has been removed, simply signup again.")
    }
    
    func displayAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
            UIAlertAction in self.checkServerStatus()// self.redirectUser()
        }
        alertController.addAction(okAction)
        //alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func signUpOrLogin(_ sender: Any) {
        activityIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
        if usernameField.text == "" && passwordField.text == "" {
            displayAlert(title: "Invalid Values", message: "Please ensure all fields are filled in properly")
        } else {
            if authMode {
                let user = PFUser()
                user.username = usernameField.text?.components(separatedBy: "@")[0]
                user.email = usernameField.text
                user.password = passwordField.text
                
                user.signUpInBackground(block: { (success, error) in
                    if error != nil {
                        var errorMessage = "Sign Up failed, please try again later"
                        let error = error as NSError?
                        if let parseError = error?.userInfo["error"] as? String {
                            errorMessage = parseError
                        }
                        //display error
                        UIApplication.shared.endIgnoringInteractionEvents()
                        self.activityIndicator.stopAnimating()
                        self.displayAlert(title: "Sign Up Error", message: errorMessage)
                    } else {
                        //Signed Up
                        //redirect
                        self.activityIndicator.stopAnimating()
                        UIApplication.shared.endIgnoringInteractionEvents()
                        self.performSegue(withIdentifier: "accountTypeSegue", sender: self)
                    }
                })
            } else {
                PFUser.logInWithUsername(inBackground: usernameField.text!.components(separatedBy: "@")[0], password: passwordField.text!, block: { (user, error) in
                    if error != nil {
                        var errorMessage = "Login failed, please try again later"
                        let error = error as NSError?
                        if let parseError = error?.userInfo["error"] as? String {
                            errorMessage = parseError
                        }
                        //display error
                        UIApplication.shared.endIgnoringInteractionEvents()
                        self.activityIndicator.stopAnimating()
                        self.displayAlert(title: "Login Error", message: errorMessage)
                    } else {
                        //Logged In
                        //self.redirectUser()
                        self.checkServerStatus()
                        UIApplication.shared.endIgnoringInteractionEvents()
                    }
                })
            }
        }
    }
    
    @IBAction func changeMode(_ sender: Any) {
        if authMode {
            authMode = false
            signUpOrLoginButton.setTitle("Login", for: [])
            changeModeButton.setTitle("Sign Up", for: [])
        } else {
            authMode = true
            signUpOrLoginButton.setTitle("Sign Up", for: [])
            changeModeButton.setTitle("Login", for: [])
        }
    }
    
    func redirectUser() {
        if PFUser.current() != nil {
            let query = PFUser.query()
            query?.whereKey("objectId", equalTo: (PFUser.current()?.objectId!)!)
            query?.findObjectsInBackground(block: { (objects, error) in
                if let users = objects {
                    for object in users {
                        if let user = object as? PFUser {
                            self.isTrainer = user["isTrainer"] as! Bool
                            
                            if self.isTrainer {
                                if user["photo"] != nil && user["gender"] != nil && user["dob"] != nil && user["userHeight"] != nil {
                                    let query = PFQuery(className: "Trainers")
                                    query.whereKey("username", equalTo: (PFUser.current()?["username"])!)
                                    query.findObjectsInBackground(block: { (objects, error) in
                                        if let trainers = objects {
                                            for object in trainers {
                                                if let trainer = object as? PFObject {
                                                    if trainer["trainerCert"] != nil && trainer["specialty"] != nil {
                                                        self.performSegue(withIdentifier: "segueHomeFromLogin", sender: nil)
                                                    } else {
                                                        self.performSegue(withIdentifier: "trainerDetails", sender: nil)
                                                    }
                                                }
                                            }
                                        }
                                    })
                                } else {
                                    self.performSegue(withIdentifier: "trainerDetails", sender: nil)
                                }
                            } else {
                                if user["photo"] != nil && user["gender"] != nil && user["dob"] != nil && user["currentWeight"] != nil && user["weightGoal"] != nil && user["userHeight"] != nil && user["weeklyGoal"] != nil && user["desiredOutcome"] != nil {
                                    self.performSegue(withIdentifier: "segueHomeFromLogin", sender: nil)
                                } else {
                                    self.performSegue(withIdentifier: "goToUserDetails", sender: nil)
                                }
                            }
                        }
                    }
                }
            })
        }
    }
    
    func checkServerStatus() {
        PFConfig.getInBackground { (config, error) in
            let serverStatus = config?["serverStatus"] as? Bool
            if serverStatus! {
                self.redirectUser()
            } else {
                self.displayAlert(title: "Server Status", message: "We apolgize the servers are currently being worked on at this time to bring you the best experience possible!")
            }
        }
    }
}
