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
    let preferences = UserDefaults.standard
    
    @IBOutlet weak var signUpButton: SignUpButton!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    @IBAction func signUp(_ sender: Any) {
        Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
            if error == nil {
                self.preferences.set(true, forKey: "isLoggedIn")
                
                self.performSegue(withIdentifier: "signUpToHomeSegue", sender: self)
            } else {
                Helper.displayAlert(title: "Error", message: (error?.localizedDescription)!)
            }
        }
    }
    
    //MARK: LIfecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}
