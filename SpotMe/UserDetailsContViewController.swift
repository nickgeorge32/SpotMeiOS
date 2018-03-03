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
        Helper.instance.displayAlert(alertTitle: "Info", message: "The information collected is used soley to help you meet your fitness goals", actionTitle: "Dismiss", style: .default, handler: {_ in })
        
    }
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addDoneButtonOnKeyboard()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let imageRef = storage.reference().child("userImages/\(UserDefaults.standard.string(forKey: "username")!)/profileImg.jpg")
        let ref = FIRESTORE_DB_USERS.document(UserDefaults.standard.string(forKey: "username")!)
        if segue.identifier == "segueHome" {
            let imageData = UIImagePNGRepresentation(profileImage)
            let _uploadTask = imageRef.putData(imageData!, metadata: nil)
            ref.updateData(["gender" : userGender, "dob" : dob, "currentWeight" : userWeight, "height" : userHeight.text!, "weightGoal" : weightGoalSegment.titleForSegment(at: weightGoalSegment.selectedSegmentIndex)!, "goalWeight" : goalWeightField.text!, "desiredOutcome" : desiredOutcomeSegment.titleForSegment(at: desiredOutcomeSegment.selectedSegmentIndex)!, "receiveEmails" : emailSwitch.isOn, "profileComplete": true])
            
            let currentUser = User.init(fullName: nil, email: nil, provider: nil, accountType: "trainer", profileImage: nil, username: nil, gender: nil, dob: nil, currentWeight: nil, height: nil, goal: nil, goalWeight: nil, weeklyGoal: nil, desiredOutcome: nil, receiveEmails: nil, fcmToken: nil, profileComplete: true)
            
            if weightGoalSegment.selectedSegmentIndex != 1 {
                ref.updateData(["weeklyGoal" : weeklyGoalSegment.titleForSegment(at: weeklyGoalSegment.selectedSegmentIndex)!])
            }
            
            ref.updateData(["fcmToken" : token])
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "back" {
            return true
        } else {
            if weightGoalSegment.selectedSegmentIndex == 0 {
                if (userHeight.text?.isEmpty)! || (goalWeightField.text?.isEmpty)! {
                    Helper.instance.displayAlert(alertTitle: "Error in Form", message: "All fields must be filled", actionTitle: "Dismiss", style: .default, handler: {_ in })
                    return false
                } else {
                    if Int(goalWeightField.text!)! > Int(userWeight)! {
                        Helper.instance.displayAlert(alertTitle: "Error in Selection", message: "Because you chose to lose weight, your goal weight should be less than your current weight", actionTitle: "Dismiss", style: .default, handler: {_ in })
                        return false
                    }
                    return true
                }
                
            } else if weightGoalSegment.selectedSegmentIndex == 1 {
                if (userHeight.text?.isEmpty)! {
                    Helper.instance.displayAlert(alertTitle: "Error in Form", message: "All fields must be filled", actionTitle: "Dismiss", style: .default, handler: {_ in })
                    return false
                } else {
                    return true
                }
            } else {
                if (userHeight.text?.isEmpty)! || (goalWeightField.text?.isEmpty)! {
                    Helper.instance.displayAlert(alertTitle: "Error in Form", message: "All fields must be filled", actionTitle: "Dismiss", style: .default, handler: {_ in })
                    return false
                } else {
                    if Int(goalWeightField.text!)! < Int(userWeight)! {
                        Helper.instance.displayAlert(alertTitle: "Error in Selection", message: "Because you chose to gain weight, your goal weight should be more than your current weight", actionTitle: "Dismiss", style: .default, handler: {_ in })
                        return false
                    }
                    return true
                }
                
            }
        }
        
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

