//
//  AccountTypeViewController.swift
//  SpotMe
//
//  Created by Nicholas George on 7/4/17.
//  Copyright © 2017 Nicholas George. All rights reserved.
//

import UIKit

class AccountTypeViewController: UIViewController {
    //MARK: Outlets and Variables
    @IBAction func trainerButton(_ sender: Any) {
        performSegue(withIdentifier: "trainerDetailsSegue", sender: nil)
    }
    
    @IBAction func joeButton(_ sender: Any) {
        performSegue(withIdentifier: "userDetailsSegue", sender: nil)
    }
    
    //MARK: LIfecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

