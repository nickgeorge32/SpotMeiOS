//
//  UserDetailsContViewController.swift
//  SpotMe
//
//  Created by Nicholas George on 3/18/17.
//  Copyright © 2017 Nicholas George. All rights reserved.
//

import UIKit
import Firebase

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
    var isTrainer:Bool!
    
    let storage = Storage.storage().reference()
    var dbRef:DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dbRef = Database.database().reference()
        
        addDoneButtonOnKeyboard()
        
    }
    
    func displayAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func weightGoal(_ sender: Any) {
        if weightGoalSegment.selectedSegmentIndex == 0 {
            goalWeightField.isHidden = false
            weeklyGoalSegment.isEnabled = true
        } else if weightGoalSegment.selectedSegmentIndex == 1 {
            goalWeightField.isHidden = true
            weeklyGoalSegment.isEnabled = false
        } else {
            goalWeightField.isHidden = false
            weeklyGoalSegment.isEnabled = true
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueHome" {
            let imageData = UIImagePNGRepresentation(profileImage)
            let profileImgRef = storage.child((Auth.auth().currentUser?.uid)!).child("images/profile.jpg")
            let uploadTask = profileImgRef.putData(imageData!, metadata: nil, completion: { (metadata, error) in
                if let error = error {
                    print(error.localizedDescription)
                    return
                } else {
                    let downloadURL = metadata?.downloadURL()?.absoluteString
                    self.dbRef.child("users").child((Auth.auth().currentUser?.uid)!).updateChildValues(["userPhoto":downloadURL])
                }
            })
            if weightGoalSegment.selectedSegmentIndex != 1 {
                dbRef.child("users").child((Auth.auth().currentUser?.uid)!).updateChildValues(["gender":userGender, "dob":dob, "currentWeight":userWeight, "userHeight":userHeight.text, "weightGoal":weightGoalSegment.titleForSegment(at: weightGoalSegment.selectedSegmentIndex), "goalWeight":goalWeightField.text, "desiredOutcome":desiredOutcomeSegment.titleForSegment(at: desiredOutcomeSegment.selectedSegmentIndex), "receiveEmails":emailSwitch.isOn, "weeklyGoal":weeklyGoalSegment.titleForSegment(at: weeklyGoalSegment.selectedSegmentIndex)])
            }
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if weightGoalSegment.selectedSegmentIndex == 0 {
            if (userHeight.text?.isEmpty)! || (goalWeightField.text?.isEmpty)! {
                displayAlert(title: "Error in form", message: "All fields must be filled")
                return false
            } else {
                if Int(goalWeightField.text!)! > Int(userWeight)! {
                    displayAlert(title: "Error in selection", message: "Because you chose to lose weight, your goal weight should be less than your current weight")
                    return false
                }
                return true
            }
            
        } else if weightGoalSegment.selectedSegmentIndex == 1 {
            if (userHeight.text?.isEmpty)! {
                displayAlert(title: "Error in form", message: "All fields must be filled")
                return false
            } else {
                return true
            }
        } else {
            if (userHeight.text?.isEmpty)! || (goalWeightField.text?.isEmpty)! {
                displayAlert(title: "Error in form", message: "All fields must be filled")
                return false
            } else {
                if Int(goalWeightField.text!)! < Int(userWeight)! {
                    displayAlert(title: "Error in Selection", message: "Because you chose to gain weight, your goal weight should be more than your current weight")
                    return false
                }
                return true
            }
            
        }
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
    
    @IBAction func disclaimer(_ sender: Any) {
        displayAlert(title: "Info", message: "The information collected is used soley to help you meet your fitness goals")
        
    }
    
}
