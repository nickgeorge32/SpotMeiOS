//
//  TrainerDetailsViewController.swift
//  SpotMe
//
//  Created by Nicholas George on 7/4/17.
//  Copyright © 2017 Nicholas George. All rights reserved.
//

import UIKit

class TrainerDetailsViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate {
    //MARK: Outlets and Variables
    @IBOutlet var profileImage: UIImageView!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet var genderSegment: UISegmentedControl!
    @IBOutlet weak var dobField: UITextField!
    @IBOutlet weak var userWeightField: UITextField!
    
    var isTrainer:Bool!
    
    @IBAction func disclaimer(_ sender: Any) {
        displayAlert(title: "Info", message: "The information collected is used soley to help you meet your fitness goals")
    }
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "moreTrainerDetails" {
            let detailsCont = segue.destination as! TrainerDetailsContViewController
            detailsCont.username = usernameField.text
            detailsCont.userGender = genderSegment.titleForSegment(at: genderSegment.selectedSegmentIndex)
            detailsCont.profileImage = profileImage.image
            detailsCont.isTrainer = isTrainer
            if dobField.text != "" && userWeightField.text != "" {
                detailsCont.dob = dobField.text
                detailsCont.userWeight = userWeightField.text
            }
        }
    }
    
    //MARK: Image
    @IBAction func uploadProfileImage(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        imagePicker.allowsEditing = false
        
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            profileImage.image = image
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK: DOB
    @IBAction func setDOB(_ sender: UITextField) {
        let inputView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 240))
        let datePickerView: UIDatePicker = UIDatePicker(frame: CGRect(x: 0, y: 40, width: 0, height: 0))
        datePickerView.datePickerMode = UIDatePickerMode.date
        inputView.addSubview(datePickerView)
        
        let doneButton = UIButton(frame: CGRect(x: (self.view.frame.size.width/2) - 50, y: 0, width: 100, height: 50))
        doneButton.setTitle("Done", for: .normal)
        doneButton.setTitle("Done", for: .highlighted)
        doneButton.setTitleColor(UIColor.black, for: .normal)
        doneButton.setTitleColor(UIColor.gray, for: .highlighted)
        
        inputView.addSubview(doneButton)
        
        doneButton.addTarget(self, action: #selector(TrainerDetailsViewController.doneButton(sender:)), for: UIControlEvents.touchUpInside)
        
        sender.inputView = inputView
        datePickerView.addTarget(self, action: #selector(TrainerDetailsViewController.datePickerValueChanged(sender:)), for: UIControlEvents.valueChanged)
        
        datePickerValueChanged(sender: datePickerView)
    }
    
    @objc func datePickerValueChanged(sender:UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.medium
        dateFormatter.timeStyle = DateFormatter.Style.none
        dobField.text = dateFormatter.string(from: sender.date)
    }
    
    //MARK: Display Alert
    func displayAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    //MARK: Misc
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
    @objc func doneButton(sender:UIButton) {
        dobField.resignFirstResponder() // To resign the inputView on clicking done.
    }
}

