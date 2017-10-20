//
//  TrainerDetailsContViewController.swift
//  SpotMe
//
//  Created by Nick George on 8/5/17.
//  Copyright © 2017 Nicholas George. All rights reserved.
//

import UIKit
import Firebase

class TrainerDetailsContViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    //MARK: Outlets and Variables
    var profileImage:UIImage!
    var userGender:String!
    var dob:String!
    var userWeight:String!
    var isTrainer:Bool!
    var username: String!
    
    let storage = Storage.storage()

    @IBOutlet weak var certImage: UIImageView!
    @IBOutlet weak var check: UIImageView!
    @IBOutlet weak var userHeight: UITextField!
    @IBOutlet weak var specialtySegment: UISegmentedControl!
    @IBOutlet weak var emailSwitch: UISwitch!
    
    @IBAction func disclaimer(_ sender: Any) {
        displayAlert(title: "Info", message: "The information collected is used soley to help you meet your fitness goals")
        
    }
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addDoneButtonOnKeyboard()
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
        let imageRef = storage.reference().child("trainerImages/\(username!)/profileImg.jpg")
        let certImgRef = storage.reference().child("trainerCerts/\(username!)/certImg.jpg")
        let ref = Firestore.firestore().collection("trainers").document(username)
        if segue.identifier == "segueHome" {
            let imageData = UIImageJPEGRepresentation(profileImage, 0.1)
            let certData = UIImageJPEGRepresentation(certImage.image!, 0.1)
            let uploadProfileImgUploadTask = imageRef.putData(imageData!, metadata: nil)
            let certImgUploadTask = certImgRef.putData(certData!, metadata: nil)
            ref.setData(["specialty" : specialtySegment.titleForSegment(at: specialtySegment.selectedSegmentIndex), "username" : username, "gender" : userGender, "dob" : dob, "currentWeight" : userWeight, "height" : userHeight.text, "receiveEmails" : emailSwitch.isOn])
        }
    }
    
    //MARK: Cert Upload
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
    
    //MARK: Display Alert
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
        
    }
    
    @objc func doneButtonAction() {
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
