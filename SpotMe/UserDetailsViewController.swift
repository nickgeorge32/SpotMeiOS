//
//  UserDetailsViewController.swift
//  SpotMe
//
//  Created by Nicholas George on 3/18/17.
//  Copyright © 2017 Nicholas George. All rights reserved.
//

import UIKit

class UserDetailsViewController: UIViewController {
    @IBOutlet var userImage: UIImageView!
    @IBOutlet var genderSegment: UISegmentedControl!
    @IBOutlet var dobButton: UIButton!
    @IBOutlet var currentWeightButton: UIButton!

    @IBAction func nextDetails(_ sender: Any) {
        performSegue(withIdentifier: "moreDetails", sender: self)
    }
    @IBAction func updateProfileImage(_ sender: Any) {
        
    }
    @IBAction func gender(_ sender: Any) {
        
    }
    @IBAction func dob(_ sender: Any) {
        
    }
    @IBAction func currentWeight(_ sender: Any) {
        
    }
    @IBAction func disclaimer(_ sender: Any) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
