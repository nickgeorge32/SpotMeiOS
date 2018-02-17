//
//  AuthViewController.swift
//  SpotMe
//
//  Created by Nick George on 11/16/17.
//  Copyright © 2017 Nicholas George. All rights reserved.
//

import UIKit
import Firebase

class SignUpVC: UIViewController {
    //MARK: Outlets and Variables
    @IBOutlet weak var signUpButton: SignUpButton!
    @IBOutlet weak var fullNameTextField: customTextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var usernameTextField: customTextField!
    @IBOutlet weak var checkImg: UIImageView!
    
    let defaults = UserDefaults.standard
    
    @IBAction func signUp(_ sender: Any) {
        AuthService.instance.registerUser(fullName: fullNameTextField.text! ,withUsername: usernameTextField.text!, withEmail: emailTextField.text!, andPassword: passwordTextField.text!) { (success, registerError) in
            if success {
                self.defaults.set(self.usernameTextField.text, forKey: "username")
                self.defaults.set(self.emailTextField.text, forKey: "email")
                self.defaults.set(self.fullNameTextField.text, forKey: "name")
                
                Auth.auth().currentUser?.sendEmailVerification(completion: { (error) in
                })
                
                self.performSegue(withIdentifier: "segueAccountTypeVC", sender: nil)
                
            } else {
                Helper.instance.displayAlert(alertTitle: "Error", message: (registerError?.localizedDescription)!, actionTitle: "Dismiss", style: .default, handler: {_ in })
            }
        }
    }
    

    
    //MARK: LIfecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        usernameTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        signUpButton.alpha = 0.5
        signUpButton.isEnabled = false
    }
    
    @IBAction func textFieldChanged(_ sender: UITextField) {
        if usernameTextField.text != "" {
            DataService.instance.checkUsernameAvailability(username: usernameTextField.text!) { (available, error) in
                if available {
                    self.checkImg.alpha = 1.0
                    self.signUpButton.alpha = 1.0
                    self.signUpButton.isEnabled = true
                } else {
                    self.checkImg.alpha = 0.05
                    self.signUpButton.alpha = 0.5
                    self.signUpButton.isEnabled = false
                    Helper.instance.displayAlert(alertTitle: "Unavailable", message: "That username is already in use", actionTitle: "Dismiss", style: .default, handler: {_ in })
                }
            }
        } else {
            checkImg.alpha = 0.1
            signUpButton.alpha = 0.5
            signUpButton.isEnabled = false
        }
    }
}

extension SignUpVC: UITextFieldDelegate {
    
}
