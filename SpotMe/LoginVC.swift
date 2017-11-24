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
    
    var ref: DocumentReference? = nil
    var username: String?
    
    @IBAction func login(_ sender: Any) {
        if usernameSwitch.isOn {
            preferences.set(usernameTextField.text, forKey: "username")
        } else {
            preferences.set(nil, forKey: "username")
        }
        Auth.auth().signIn(withEmail: usernameTextField.text!, password: passwordTextField.text!) { (user, error) in
            if error == nil {
                    if self.username != nil {
                        self.ref = Firestore.firestore().collection("users").document(self.username!)
                        self.ref?.getDocument(completion: { (userDoc, error) in
                            if let document = userDoc {
                                if document.exists {
                                    self.performSegue(withIdentifier: "segueHome", sender: self)
                                } else {
                                    print("Document does not exist")
                                    self.ref = Firestore.firestore().collection("trainers").document((self.preferences.string(forKey: "username"))!)
                                    self.ref?.getDocument(completion: { (trainerDoc, error) in
                                        if let document = trainerDoc {
                                            if document.exists {
                                                self.performSegue(withIdentifier: "segueHome", sender: self)
                                            } else {
                                                self.performSegue(withIdentifier: "completeProfileSegue", sender: self)
                                            }
                                        }
                                    })
                                }
                            }
                        })
                    } else {
                        self.performSegue(withIdentifier: "completeProfileSegue", sender: self)
                    }
                
                self.performSegue(withIdentifier: "loginToHomeSegue", sender: self)
                } else {
                    Helper.displayAlert(title: "Error", message: (error?.localizedDescription)!)
                }
        }
    }
    
    //MARK Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        username = preferences.string(forKey: "username")!
    }
}
