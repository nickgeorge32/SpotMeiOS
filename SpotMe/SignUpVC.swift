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
        AuthService.instance.registerUser(withEmail: emailTextField.text!, andPassword: passwordTextField.text!) { (success, registerError) in
            if success {
                self.performSegue(withIdentifier: "segueAccountTypeVC", sender: nil)
            } else {
                Helper.displayAlert(title: "Error", message: (registerError?.localizedDescription)!)
            }
        }
    }
    
    //MARK: LIfecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
}

extension SignUpVC: UITextFieldDelegate {
    
}
