//
//  TrainerDetailsContViewController.swift
//  SpotMe
//
//  Created by Nick George on 8/5/17.
//  Copyright © 2017 Nicholas George. All rights reserved.
//

import UIKit
import Parse

class TrainerDetailsContViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var profileImage:UIImage!
    var userGender:String!
    var dob:String!
    var userWeight:String!
    var isTrainer:Bool!

    @IBOutlet weak var certImage: UIImageView!
    @IBOutlet weak var check: UIImageView!
    @IBOutlet weak var userHeight: UITextField!
    @IBOutlet weak var specialtySegment: UISegmentedControl!
    @IBOutlet weak var emailSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addDoneButtonOnKeyboard()
    }
    
    @IBAction func uploadCertButton(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        imagePicker.sourceType = UIImagePickerControllerSourceType.camera
        imagePicker.cameraCaptureMode = .photo
        imagePicker.modalPresentationStyle = .fullScreen
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            certImage.image = image
        }
        self.dismiss(animated: true) { 
            self.check.alpha = 1.0
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "back" {
            return true
        } else {
            if (userHeight.text?.isEmpty)! || certImage.image == nil {
                displayAlert(title: "Error in Form", message: "All fields must be filled")
                return false
            } else {
                return true
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueHome" {
            //let imageData = UIImagePNGRepresentation(profileImage)
            let imageData = UIImageJPEGRepresentation(profileImage, 0.1)
            let certData = UIImageJPEGRepresentation(certImage.image!, 0.1)
            let trainer = PFObject(className: "Trainers")
            trainer["specialty"] = specialtySegment.titleForSegment(at: specialtySegment.selectedSegmentIndex)
            trainer["trainerCert"] = PFFile(name: "trainerCert.jpg", data: certData!)
            trainer["username"] = PFUser.current()?["username"]
            trainer.saveInBackground()
            
            PFUser.current()?["photo"] = PFFile(name: "profile.jpg", data: imageData!)
            PFUser.current()?["gender"] = userGender
            PFUser.current()?["dob"] = dob
            PFUser.current()?["isTrainer"] = isTrainer
            PFUser.current()?["currentWeight"] = userWeight
            PFUser.current()?["userHeight"] = userHeight.text
            PFUser.current()?["receiveEmails"] = emailSwitch.isOn
            
            PFUser.current()?.saveInBackground(block: { (success, error) in
                if error != nil {
                    var errorMessage = "Unable to save details"
                    if let parseError = (error!as NSError).userInfo["error"] as? String {
                        errorMessage = parseError
                        self.displayAlert(title: "Error", message: errorMessage)
                    }
                } else {
                    self.displayAlert(title: "Success", message: "Profile Saved!")
                }
            })
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
        
    }
    
    func doneButtonAction() {
        self.userHeight.resignFirstResponder()
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
    func displayAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    
}
