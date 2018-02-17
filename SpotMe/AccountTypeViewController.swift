//
//  AccountTypeViewController.swift
//  SpotMe
//
//  Created by Nicholas George on 7/4/17.
//  Copyright © 2017 Nicholas George. All rights reserved.
//

import UIKit
import Firebase

class AccountTypeViewController: UIViewController {
    //MARK: Outlets and Variables
    @IBOutlet weak var trainerImgButton: UIButton!
    @IBOutlet weak var avgJoeImgButton: UIButton!
    let defaults = UserDefaults.standard
    
    @IBAction func trainerButton(_ sender: Any) {
        defaults.set("trainer", forKey: "accountType")
        performSegue(withIdentifier: "trainerDetailsSegue", sender: nil)
    }
    
    @IBAction func joeButton(_ sender: Any) {
        defaults.set("user", forKey: "accountType")
        let userData = ["email": defaults.string(forKey: "email")!, "provider": Auth.auth().currentUser?.providerID, "profileComplete": false] as [String : Any]
        DataService.instance.createDBUser(firestoreRef: FIRESTORE_DB_USERS.document(defaults.string(forKey: "username")!), username: defaults.string(forKey: "username")!, userData: userData)
        performSegue(withIdentifier: "userDetailsSegue", sender: nil)
    }
    
    //MARK: LIfecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        trainerImgButton.imageView?.contentMode = UIViewContentMode.scaleAspectFit
        avgJoeImgButton.imageView?.contentMode = UIViewContentMode.scaleAspectFit
    }
}

