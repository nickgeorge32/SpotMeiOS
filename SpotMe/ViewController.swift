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
                let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                    UIAlertAction in self.redirectUser()
                }
                alertController.addAction(okAction)
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
                                self.redirectUser()
                                UIApplication.shared.endIgnoringInteractionEvents()
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
    
    //TODO: download already saved data if any so user does not have to refill all fields
    func redirectUser() {
        //check if there is a user logged in
        Auth.auth().addStateDidChangeListener { (auth, user) in
            if user != nil {
                //if there is a user check whether is trainer and all fields are saved
                self.dbRef.child("users").child((Auth.auth().currentUser?.uid)!).observeSingleEvent(of: .value, with: { (snapshotTop) in
                    if snapshotTop.hasChild("isTrainer") {
                        //check if isTrainer
                        self.dbRef.child("users").child((Auth.auth().currentUser?.uid)!).child("isTrainer").observeSingleEvent(of: .value, with: { (snapshotBot) in
                            self.isTrainer = snapshotBot.value as! Bool
                            if self.isTrainer {
                                //if isTrainer and is not missing data
                                if snapshotTop.hasChild("currentWeight") && snapshotTop.hasChild("desiredOutcome") && snapshotTop.hasChild("dob") && snapshotTop.hasChild("email") && snapshotTop.hasChild("gender") && snapshotTop.hasChild("goalWeight") && snapshotTop.hasChild("userHeight") && snapshotTop.hasChild("weeklyGoal") && snapshotTop.hasChild("userPhoto") && snapshotTop.hasChild("weightGoal") {
                                    self.performSegue(withIdentifier: "segueHomeFromLogin", sender: nil)
                                } else {
                                    //is trainer and is missing data
                                    self.performSegue(withIdentifier: "trainerDetails", sender: nil)
                                }
                            } else {
                                //is not trainer and is not missing data
                                if snapshotTop.hasChild("currentWeight") && snapshotTop.hasChild("desiredOutcome") && snapshotTop.hasChild("dob") && snapshotTop.hasChild("email") && snapshotTop.hasChild("gender") && snapshotTop.hasChild("goalWeight") && snapshotTop.hasChild("userHeight") && snapshotTop.hasChild("weeklyGoal") && snapshotTop.hasChild("userPhoto") && snapshotTop.hasChild("weightGoal") {
                                    self.performSegue(withIdentifier: "segueHomeFromLogin", sender: nil)
                                } else {
                                    //is not trainer and is missing data
                                    //comment
                                    self.performSegue(withIdentifier: "goToUserDetails", sender: nil)
                                }
                            }
                        })
                    }
                })
            }
        }
    }
}

