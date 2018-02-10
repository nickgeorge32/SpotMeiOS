//
//  UserDetailsViewController.swift
//  SpotMe
//
//  Created by Nicholas George on 3/18/17.
//  Copyright © 2017 Nicholas George. All rights reserved.
//

import UIKit

class UserDetailsViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate {
    //MARK: Outlets and Variables
    @IBOutlet var userImage: UIImageView!
    @IBOutlet var genderSegment: UISegmentedControl!
    @IBOutlet var dobField: UITextField!
    @IBOutlet var userWeightField: UITextField!
    
    var isTrainer: Bool!
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addDoneButtonOnKeyboard()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "moreDetails" {
            let detailsCont = segue.destination as! UserDetailsContViewController
            detailsCont.userGender = genderSegment.titleForSegment(at: genderSegment.selectedSegmentIndex)
            detailsCont.profileImage = UIImage(data: UIImageJPEGRepresentation(userImage.image!, 0.1)!)
            detailsCont.isTrainer = isTrainer
            if dobField.text != "" && userWeightField.text != "" {
                detailsCont.dob = dobField.text
                detailsCont.userWeight = userWeightField.text
            }
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if (dobField.text?.isEmpty)! || (userWeightField.text?.isEmpty)! {
            Helper.instance.displayAlert(alertTitle: "Error in Form", message: "All fields must be filled", actionTitle: "Dismiss", style: .default, handler: {_ in })
            return false
        } else {
            return true
        }
    }
    
    //MARK: Image
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            userImage.image = image
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func updateProfileImage(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        imagePicker.allowsEditing = false
        
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    //MARK: DOB
    @IBAction func setDOB(_ sender: UITextField) {
        let inputView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 240))
        
        
        let datePickerView:UIDatePicker = UIDatePicker(frame: CGRect(x: 0,y: 40,width: 0,height: 0))
        datePickerView.datePickerMode = UIDatePickerMode.date
        inputView.addSubview(datePickerView) // add date picker to UIView
        
        let doneButton = UIButton(frame: CGRect(x: (self.view.frame.size.width/2) - 50,y: 0,width: 100,height: 50))
        doneButton.setTitle("Done", for: UIControlState.normal)
        doneButton.setTitle("Done", for: UIControlState.highlighted)
        doneButton.setTitleColor(UIColor.black, for: UIControlState.normal)
        doneButton.setTitleColor(UIColor.gray, for: UIControlState.highlighted)
        
        inputView.addSubview(doneButton) // add Button to UIView
        
        doneButton.addTarget(self, action: #selector(UserDetailsViewController.doneButton(sender:)), for: UIControlEvents.touchUpInside) // set button click event
        
        sender.inputView = inputView
        datePickerView.addTarget(self, action: #selector(UserDetailsViewController.datePickerValueChanged(sender:)), for: UIControlEvents.valueChanged)
        
        datePickerValueChanged(sender: datePickerView) // Set the date on start.
    }
    
    @objc func datePickerValueChanged(sender:UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.medium
        dateFormatter.timeStyle = DateFormatter.Style.none
        dobField.text = dateFormatter.string(from: sender.date)
    }
    
    @objc func doneButton(sender:UIButton) {
        dobField.resignFirstResponder() // To resign the inputView on clicking done.
    }
    
    //MARK: Misc
    @IBAction func disclaimer(_ sender: Any) {
        Helper.instance.displayAlert(alertTitle: "Info", message: "The information collected is used soley to help you meet your fitness goals", actionTitle: "OK", style: .default, handler: {_ in })
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
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
        
        self.userWeightField.inputAccessoryView = doneToolbar
        
    }
    
    @objc func doneButtonAction() {
        self.userWeightField.resignFirstResponder()
    }
}

