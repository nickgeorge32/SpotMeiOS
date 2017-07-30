//
//  AccountTypeViewController.swift
//  SpotMe
//
//  Created by Nicholas George on 7/4/17.
//  Copyright © 2017 Nicholas George. All rights reserved.
//

//TODO: add images for Joe and Trainer

import UIKit
import Firebase

class AccountTypeViewController: UIViewController {
    var isTrainer:Bool!
    
    var dbRef:DatabaseReference!


    @IBAction func trainerButton(_ sender: Any) {
        isTrainer = true
        dbRef.database.reference().child("users").child((Auth.auth().currentUser?.uid)!).updateChildValues(["isTrainer":isTrainer])
    }
    @IBAction func joeButton(_ sender: Any) {
        isTrainer = false
        dbRef.database.reference().child("users").child((Auth.auth().currentUser?.uid)!).updateChildValues(["isTrainer":isTrainer])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        dbRef = Database.database().reference()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "trainerDetails" {
            let destination = segue.destination as! TrainerDetailsViewController
            isTrainer = true
            destination.isTrainer = isTrainer
        } else if segue.identifier == "goToUserDetails" {
            let destinaion = segue.destination as! UserDetailsViewController
            isTrainer = false
            destinaion.isTrainer = isTrainer
        }
    }
}
