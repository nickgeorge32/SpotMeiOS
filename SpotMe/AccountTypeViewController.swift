//
//  AccountTypeViewController.swift
//  SpotMe
//
//  Created by Nicholas George on 7/4/17.
//  Copyright © 2017 Nicholas George. All rights reserved.
//

import UIKit

class AccountTypeViewController: UIViewController {
    var isTrainer:Bool!
    
    @IBAction func trainerButton(_ sender: Any) {
        isTrainer = true
    }
    @IBAction func joeButton(_ sender: Any) {
        isTrainer = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
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

