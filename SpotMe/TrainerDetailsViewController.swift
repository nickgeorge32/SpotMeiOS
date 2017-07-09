//
//  TrainerDetailsViewController.swift
//  SpotMe
//
//  Created by Nicholas George on 7/4/17.
//  Copyright © 2017 Nicholas George. All rights reserved.
//

import UIKit
import Parse

class TrainerDetailsViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate {

    @IBOutlet var profileImage: UIImageView!
    @IBOutlet var genderSegment: UISegmentedControl!
    @IBOutlet var specialtySegment: UISegmentedControl!
    @IBOutlet var emailsSwitch: UISwitch!
    
    var isTrainer:Bool!
    
    @IBAction func uploadProfileImage(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        imagePicker.allowsEditing = false
        
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func uploadCertButton(_ sender: Any) {
        let imaePicker = UIImagePickerController()
        imaePicker.allowsEditing = false
        imaePicker.sourceType = UIImagePickerControllerSourceType.camera
        imaePicker.cameraCaptureMode = .photo
        imaePicker.modalPresentationStyle = .fullScreen
        self.present(imaePicker, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        print("trainer: \(isTrainer)")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueHomeAsTrainer" {
            print(isTrainer)
            
            let imageData = UIImagePNGRepresentation(profileImage.image!)
            PFUser.current()?["photo"] = PFFile(name: "profile.png", data: imageData!)
            PFUser.current()?["gender"] = genderSegment.titleForSegment(at: genderSegment.selectedSegmentIndex)
            PFUser.current()?["isTrainer"] = isTrainer
            PFUser.current()?["receiveEmails"] = emailsSwitch.isOn
            
            PFUser.current()?.saveInBackground(block: { (success, error) in
                if error != nil {
                    
                } else {
                    
                }
            })
        }
    }
}
