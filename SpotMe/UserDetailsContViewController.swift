//
//  UserDetailsContViewController.swift
//  SpotMe
//
//  Created by Nicholas George on 3/18/17.
//  Copyright © 2017 Nicholas George. All rights reserved.
//

import UIKit

class UserDetailsContViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet var userHeight: UITextField!
    @IBOutlet var weightGoalSegment: UISegmentedControl!
    @IBOutlet var goalWeightField: UITextField!
    @IBOutlet var weeklyGoalSegment: UISegmentedControl!
    @IBOutlet var desiredOutcomeSegment: UISegmentedControl!
    @IBOutlet var emailSwitch: UISwitch!
    
    var profileImage:UIImage!
    var userGender:String!
    var dob:String!
    var userWeight:String!
    
    @IBAction func weightGoal(_ sender: Any) {
        if weightGoalSegment.selectedSegmentIndex == 0 || weightGoalSegment.selectedSegmentIndex == 2 {
            goalWeightField.isHidden = false
        } else {
            goalWeightField.isHidden = true
        }
    }
    @IBAction func weeklyGoal(_ sender: Any) {

    }
    @IBAction func desiredOutcome(_ sender: Any) {
        
    }
    
    @IBAction func save(_ sender: Any) {
        performSegue(withIdentifier: "segueHome", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addDoneButtonOnKeyboard()

        // Do any additional setup after loading the view.
        print(userGender)
        print(userWeight)
        print(dob)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addDoneButtonOnKeyboard()
    {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x:0,y: 0,width: 320,height: 50))
        doneToolbar.barStyle = UIBarStyle.default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(doneButtonAction))
        
        var items = [UIBarButtonItem]()
        items.append(flexSpace)
        items.append(done)
        
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        self.userHeight.inputAccessoryView = doneToolbar
        
    }
    
    func doneButtonAction()
    {
        self.userHeight.resignFirstResponder()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }

}
