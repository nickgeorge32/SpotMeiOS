//
//  NearbyUserInfoViewController.swift
//  SpotMe
//
//  Created by Nicholas George on 3/23/17.
//  Copyright © 2017 Nicholas George. All rights reserved.
//

import UIKit
import Parse

class NearbyUserInfoViewController: UIViewController {
    @IBOutlet var userProfileImage: UIImageView!
    @IBOutlet var username: UILabel!
    @IBOutlet var gender: UILabel!
    @IBOutlet var weightGoal: UILabel!
    @IBOutlet var desiredOutcome: UILabel!
    @IBOutlet var addUserButton: UIButton!
    @IBOutlet var rejectUserButton: UIButton!
    
    var passedUsername = ""
    var buttonText = "Add Friend"
    
    var activeRequest = false
    var pendingRequest = false
    var isFriend = false
    
    func requestActive() {
        
        let query = PFQuery(className: "FriendRequests")
        query.whereKey("requestingUser", equalTo: (PFUser.current()?.username!)!)
        query.whereKey("pendingRequestUser", equalTo: passedUsername)
        query.findObjectsInBackground { (objects, error) in
            for _ in objects! {
                self.addUserButton.setTitle("Cancel Friend Request", for: [])
                self.activeRequest = true
            }
        }
    }
    
    @IBAction func addUser(_ sender: Any) {
        if activeRequest {
            let query = PFQuery(className: "FriendRequests")
            query.whereKey("requestingUser", equalTo: (PFUser.current()?.username!)!)
            query.whereKey("pendingRequestUser", equalTo: passedUsername)
            query.findObjectsInBackground(block: { (objects, error) in
                for object in objects! {
                    object.deleteInBackground()
                }
            })
            
            buttonText = "Add Friend"
            addUserButton.setTitle(buttonText, for: [])
            activeRequest = false
        } else {
            
            let tfriends = PFObject(className: "FriendRequests")
            tfriends["requestingUser"] = PFUser.current()?.username
            tfriends["pendingRequestUser"] = passedUsername
            tfriends.saveInBackground()
            
            _ = navigationController?.popToRootViewController(animated: true)
        }
    }
    @IBAction func rejectUser(_ sender: Any) {
        let query = PFQuery(className: "FriendRequests")
        query.whereKey("requestingUser", equalTo: passedUsername)
        query.whereKey("pendingRequestUser", equalTo: (PFUser.current()?.username!)!)
        query.findObjectsInBackground(block: { (objects, error) in
            for object in objects! {
                object.deleteInBackground()
            }
        })
        activeRequest = false
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        requestActive()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = false
        username.text = passedUsername
        addUserButton.setTitle(buttonText, for: [])
        
        let query = PFUser.query()
        query?.whereKey("username", equalTo: username.text!)
        query?.findObjectsInBackground(block: { (objects, error) in
            if let users = objects {
                for object in users {
                    if let user = object as? PFUser {
                        self.gender.text = object["gender"] as! String?
                        self.weightGoal.text = object["weightGoal"] as! String?
                        self.desiredOutcome.text = object["desiredOutcome"] as! String?
                        let imageFile = user["photo"] as! PFFile
                        imageFile.getDataInBackground(block: { (data, error) in
                            if let imageData = data {
                                self.userProfileImage.image = UIImage(data: imageData)
                            }
                        })
                    }
                }
                
            }
        })

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
