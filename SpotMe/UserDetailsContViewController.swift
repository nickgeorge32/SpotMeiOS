//
//  UserDetailsContViewController.swift
//  SpotMe
//
//  Created by Nicholas George on 3/18/17.
//  Copyright © 2017 Nicholas George. All rights reserved.
//

import UIKit
import Parse

class UserDetailsContViewController: UIViewController, UITextFieldDelegate {
    var profileImage:UIImage!
    var userGender:String!
    var dob:String!
    var userWeight:String!
    
    
    @IBOutlet var userHeight: UITextField!
    @IBOutlet var weightGoalSegment: UISegmentedControl!
    @IBOutlet var goalWeightField: UITextField!
    @IBOutlet var weeklyGoalSegment: UISegmentedControl!
    @IBOutlet var desiredOutcomeSegment: UISegmentedControl!
    @IBOutlet var emailSwitch: UISwitch!
    
    @IBAction func weightGoal(_ sender: Any) {
        
    }

    @IBAction func weeklyGoal(_ sender: Any) {
        print(weeklyGoalSegment.selectedSegmentIndex)
    }
    @IBAction func desiredOutcome(_ sender: Any) {
        
    }
    
    @IBAction func save(_ sender: Any) {
        let imageData = UIImagePNGRepresentation(profileImage)
        PFUser.current()?["photo"] = PFFile(name: "profile.png", data: imageData!)
        PFUser.current()?["gender"] = userGender
        PFUser.current()?["dob"] = dob
        PFUser.current()?["currentWeight"] = userWeight
        PFUser.current()?["userHeight"] = userHeight.text
        PFUser.current()?["weightGoal"] = weightGoalSegment.titleForSegment(at: weightGoalSegment.selectedSegmentIndex)
        PFUser.current()?["goalWeight"] = goalWeightField.text
        PFUser.current()?["weeklyGoal"] = weeklyGoalSegment.titleForSegment(at: weeklyGoalSegment.selectedSegmentIndex)
        PFUser.current()?["desiredOutcome"] = desiredOutcomeSegment.titleForSegment(at: desiredOutcomeSegment.selectedSegmentIndex)
        PFUser.current()?["receiveEmails"] = emailSwitch.isOn
        
        PFUser.current()?.saveInBackground(block: { (success, error) in
            if error != nil {
                var errorMessage = "Unable to save details"
                if let parseError = (error as! NSError).userInfo["error"] as? String {
                    errorMessage = parseError
                    self.displayAlert(title: "Error", message: errorMessage)
                }
            } else {
                self.displayAlert(title: "Success", message: "Profile Saved!")
            }
        })
        //performSegue(withIdentifier: "segueHome", sender: self)

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addDoneButtonOnKeyboard()

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addDoneButtonOnKeyboard() {
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
        self.goalWeightField.inputAccessoryView = doneToolbar
        
    }
    
    func doneButtonAction() {
        self.userHeight.resignFirstResponder()
        self.goalWeightField.resignFirstResponder()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
    func displayAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }

}
