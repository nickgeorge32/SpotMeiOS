//
//  ViewController.swift
//  SpotMe
//
//  Created by Nicholas George on 3/18/17.
//  Copyright © 2017 Nicholas George. All rights reserved.
//

import UIKit
import Parse

class ViewController: UIViewController {
    @IBOutlet var usernameField: UITextField!
    @IBOutlet var passwordField: UITextField!
    @IBOutlet var signUpOrLoginButton: UIButton!
    @IBOutlet var changeModeButton: UIButton!
    
    var authMode = true

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        redirectUser()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func displayAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func signUpOrLogin(_ sender: Any) {
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
                    print("Signed Up")
                    //redirect
                    self.performSegue(withIdentifier: "goToUserDetails", sender: self)
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
                    //redirect
                    self.redirectUser()
                }
            })
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
            if PFUser.current()?["gender"] != nil && PFUser.current()?["dob"] != nil && PFUser.current()?["currentWeight"] != nil && PFUser.current()?["userHeight"] != nil && PFUser.current()?["weightGoal"] != nil && PFUser.current()?["weeklyGoal"] != nil && PFUser.current()?["desiredOutcome"] != nil {
                performSegue(withIdentifier: "segueHomeFromLogin", sender: self)
            } else {
                performSegue(withIdentifier: "goToUserDetails", sender: self)
            }
        }
    }
}

