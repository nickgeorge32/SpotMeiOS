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
        print("trainer button: \(isTrainer)")
    }
    @IBAction func joeButton(_ sender: Any) {
        isTrainer = false
        print("joe button: \(isTrainer)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("segue: \(isTrainer)")
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
