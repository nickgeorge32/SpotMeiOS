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
    let defaults = UserDefaults.standard
    @IBOutlet weak var emailTextField: customTextField!
    @IBOutlet weak var passwordTextField: customTextField!
    @IBOutlet weak var emailSwitch: UISwitch!
    
    var ref: DocumentReference? = nil
    
    @IBAction func login(_ sender: Any) {
        if emailSwitch.isOn {
            defaults.set(true, forKey: "emailSwitch")
            defaults.set(emailTextField.text, forKey: "email")
        } else {
            defaults.set(false, forKey: "emailSwitch")
            defaults.set(nil, forKey: "email")
        }
        Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
            if error == nil {
                self.performSegue(withIdentifier: "segueHome", sender: self)
            } else {
                Helper.instance.displayAlert(alertTitle: "Error", message: (error?.localizedDescription)!, actionTitle: "Dismiss", style: .default, handler: {_ in })
            }
        }
    }
    
    //MARK Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        if defaults.string(forKey: "email") != nil && defaults.bool(forKey: "emailSwitch") != nil {
            emailTextField.text = defaults.string(forKey: "email")
            emailSwitch.setOn(defaults.bool(forKey: "emailSwitch"), animated: true)
        }
    }
}
