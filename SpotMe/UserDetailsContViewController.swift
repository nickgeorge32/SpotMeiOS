//
//  UserDetailsContViewController.swift
//  SpotMe
//
//  Created by Nicholas George on 3/18/17.
//  Copyright © 2017 Nicholas George. All rights reserved.
//

import UIKit

class UserDetailsContViewController: UIViewController {
    @IBOutlet var weightGoalSegment: UISegmentedControl!
    @IBOutlet var weeklyGoalSegment: UISegmentedControl!
    @IBOutlet var desiredOutcomeSegment: UISegmentedControl!
    @IBOutlet var emailSwitch: UISwitch!
    
    var profileImage:UIImage!
    var userGender:String!
    var dob:String! = "Jan 1, 1915"
    var userWeight:String! = ""
    
    @IBAction func weeklyGoal(_ sender: Any) {
        
    }
    @IBAction func desiredOutcome(_ sender: Any) {
        
    }
    
    @IBAction func save(_ sender: Any) {
        performSegue(withIdentifier: "segueHome", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        print(userGender)
        print(userWeight)
        print(dob)
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
