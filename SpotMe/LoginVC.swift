//
//  LoginVC.swift
//  SpotMe
//
//  Created by Nick George on 11/23/17.
//  Copyright © 2017 Nicholas George. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class LoginVC: UIViewController {
    //MARK: Outlets and Variables
    let preferences = UserDefaults.standard
    @IBOutlet weak var usernameTextField: customTextField!
    @IBOutlet weak var passwordTextField: customTextField!
    @IBOutlet weak var usernameSwitch: UISwitch!
    
    @IBAction func login(_ sender: Any) {
        if usernameSwitch.isOn {
            preferences.set(usernameTextField.text, forKey: "username")
        } else {
            preferences.set(nil, forKey: "username")
        }
        Auth.auth().signIn(withEmail: usernameTextField.text!, password: passwordTextField.text!) { (user, error) in
            if error == nil {
                self.preferences.set(true, forKey: "isLoggedIn")
                
                self.performSegue(withIdentifier: "loginToHomeSegue", sender: self)
            } else {
                Helper.displayAlert(title: "Error", message: (error?.localizedDescription)!)
            }
        }
    }
    
    //MARK Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

    }
}
