//
//  AuthViewController.swift
//  SpotMe
//
//  Created by Nick George on 11/16/17.
//  Copyright © 2017 Nicholas George. All rights reserved.
//

import UIKit
import Firebase

class AuthViewController: UIViewController {
    //MARK: Outlets and Variables
    @IBOutlet weak var loginButton: LoginButton!
    @IBOutlet weak var signUpButton: SignUpButton!
    @IBOutlet weak var pageTitle: UILabel!
    
    @IBOutlet weak var rectView: UIView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBAction func login(_ sender: Any) {
        
    }
    
    @IBAction func signUp(_ sender: Any) {
        
    }
    
    //MARK: LIfecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}
