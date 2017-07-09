//
//  UserDetailsViewController.swift
//  SpotMe
//
//  Created by Nicholas George on 3/18/17.
//  Copyright © 2017 Nicholas George. All rights reserved.
//

import UIKit

class UserDetailsViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate {
    @IBOutlet var userImage: UIImageView!
    @IBOutlet var genderSegment: UISegmentedControl!
    @IBOutlet var dobField: UITextField!
    @IBOutlet var userWeightField: UITextField!
    
    var isTrainer: Bool!
    
    @IBAction func updateProfileImage(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        imagePicker.allowsEditing = false
        
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            userImage.image = image
        }
        
        self.dismiss(animated: true, completion: nil)
    }

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
    
    func datePickerValueChanged(sender:UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.medium
        dateFormatter.timeStyle = DateFormatter.Style.none
        dobField.text = dateFormatter.string(from: sender.date)
    }
    
    func doneButton(sender:UIButton)
    {
        dobField.resignFirstResponder() // To resign the inputView on clicking done.
    }
    
    @IBAction func disclaimer(_ sender: Any) {
        displayAlert(title: "Info", message: "The information collected is used soley to help you meet your fitness goals")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "moreDetails" {
            let detailsCont = segue.destination as! UserDetailsContViewController
            detailsCont.userGender = genderSegment.titleForSegment(at: genderSegment.selectedSegmentIndex)
            detailsCont.profileImage = userImage.image
            detailsCont.isTrainer = isTrainer
            if dobField.text != "" && userWeightField.text != "" {
                detailsCont.dob = dobField.text
                detailsCont.userWeight = userWeightField.text
            }
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if (dobField.text?.isEmpty)! || (userWeightField.text?.isEmpty)! {
            displayAlert(title: "Error in form", message: "All fields must be filled")
            return false
        } else {
            return true
        }
    }
    
    func displayAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print("userD \(isTrainer)")
        // Do any additional setup after loading the view.
        addDoneButtonOnKeyboard()
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
        
        self.userWeightField.inputAccessoryView = doneToolbar
        
    }
    
    func doneButtonAction()
    {
        self.userWeightField.resignFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
