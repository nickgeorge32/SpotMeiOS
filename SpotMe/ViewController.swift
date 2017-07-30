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
    var token = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        displayAlert(title: "Beta Test", message: "Data may be erased periodically during the testing period. If you find that your account has been removed, simply signup again.")
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        token = appDelegate.token
    }
    
    func displayAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
            UIAlertAction in self.redirectUser()
        }
        alertController.addAction(okAction)
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
                        var errorMessage = "Sign Up failed, please try again later"
                        let error = error as NSError?
                        if let parseError = error?.userInfo["error"] as? String {
                            errorMessage = parseError
                        }
                        //display error
                        self.displayAlert(title: "Login Error", message: errorMessage)
                    } else {
                        //Logged In
                        self.redirectUser()
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
            if PFUser.current()?["photo"] != nil && PFUser.current()?["gender"] != nil && PFUser.current()?["dob"] != nil && PFUser.current()?["currentWeight"] != nil && PFUser.current()?["userHeight"] != nil /*&& PFUser.current()?["weightGoal"] != nil*/ && PFUser.current()?["weeklyGoal"] != nil && PFUser.current()?["desiredOutcome"] != nil {
                performSegue(withIdentifier: "segueHomeFromLogin", sender: self)
            } else {
                let query = PFUser.query()
                query?.whereKey("objectId", equalTo: (PFUser.current()?.objectId!)!)
                query?.findObjectsInBackground(block: { (objects, error) in
                    if let users = objects {
                        for object in users {
                            if let user = object as? PFUser {
                                self.isTrainer = user["isTrainer"] as! Bool
                                if self.isTrainer {
                                    self.performSegue(withIdentifier: "trainerDetails", sender: nil)
                                } else {
                                    self.performSegue(withIdentifier: "goToUserDetails", sender: nil)
                                }
                            }
                        }
                    }
                })
                
                //                if isTrainer {
                //                    performSegue(withIdentifier: "trainerDetails", sender: nil)
                //                } else {
                //                    performSegue(withIdentifier: "goToUserDetails", sender: nil)
                //                }
            }
        }
    }
}

