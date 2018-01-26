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
    //MARK: Outlets and Variables
    @IBOutlet var userHeight: UITextField!
    @IBOutlet var weightGoalSegment: UISegmentedControl!
    @IBOutlet var goalWeightField: UITextField!
    @IBOutlet var weeklyGoalSegment: UISegmentedControl!
    @IBOutlet var desiredOutcomeSegment: UISegmentedControl!
    @IBOutlet var emailSwitch: UISwitch!
    
    var username: String!
    var profileImage:UIImage!
    var userGender:String!
    var dob:String!
    var userWeight:String!
    var isTrainer:Bool!
    var token = ""
    var preferences = UserDefaults.standard
    
    let storage = Storage.storage()
    
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
    
    @IBAction func disclaimer(_ sender: Any) {
        displayAlert(title: "Info", message: "The information collected is used soley to help you meet your fitness goals")
        
    }
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addDoneButtonOnKeyboard()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let imageRef = storage.reference().child("userImages/\(username!)/profileImg.jpg")
        let ref = Firestore.firestore().collection("users").document(username)
        if segue.identifier == "segueHome" {
            let imageData = UIImagePNGRepresentation(profileImage)
            let _uploadTask = imageRef.putData(imageData!, metadata: nil)
            ref.setData(["username" : username, "gender" : userGender, "dob" : dob, "currentWeight" : userWeight, "height" : userHeight.text, "weightGoal" : weightGoalSegment.titleForSegment(at: weightGoalSegment.selectedSegmentIndex), "goalWeight" : goalWeightField.text, "desiredOutcome" : desiredOutcomeSegment.titleForSegment(at: desiredOutcomeSegment.selectedSegmentIndex), "receiveEmails" : emailSwitch.isOn])
            
            if weightGoalSegment.selectedSegmentIndex != 1 {
                ref.updateData(["weeklyGoal" : weeklyGoalSegment.titleForSegment(at: weeklyGoalSegment.selectedSegmentIndex)])
            }
            
            ref.updateData(["fcmToken" : token])
            
            preferences.set(username, forKey: "username")
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "back" {
            return true
        } else {
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
        
    }
    
    //MARK: Dislpay Alert
    func displayAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    //MARK: Misc
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
    
    @objc func doneButtonAction() {
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
}

