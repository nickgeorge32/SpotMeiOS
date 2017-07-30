//
//  SettingsViewController.swift
//  SpotMe
//
//  Created by Nicholas George on 7/29/17.
//  Copyright © 2017 Nicholas George. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func updateSettings(_ sender: Any) {
        performSegue(withIdentifier: "updateSettings", sender: nil)
    }
}
