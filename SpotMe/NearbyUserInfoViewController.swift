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
    var passedId = ""
    var buttonText = "Add Friend"
    
    var activeRequest = false
    var isFriend = false
    
    func requestActive() {
        
        let query = PFQuery(className: "FriendRequests")
        query.whereKey("requestingUser", equalTo: (PFUser.current()?.username!)!)
        query.whereKey("pendingRequestUser", equalTo: passedUsername)
        query.findObjectsInBackground { (objects, error) in
            for _ in objects! {
                self.addUserButton.isHidden = true
                self.rejectUserButton.isHidden = false
                self.rejectUserButton.frame.origin = CGPoint(x: (self.view.frame.size.width - 180) / 2, y: 410)
                self.rejectUserButton.setTitle("Cancel Friend Request", for: [])
                self.activeRequest = true
            }
        }
    }
    
    @IBAction func add_AcceptUser(_ sender: Any) {
        if addUserButton.titleLabel?.text == "Add Friend" {
            let tfriends = PFObject(className: "FriendRequests")
            tfriends["requestingUser"] = PFUser.current()?.username
            tfriends["pendingRequestUser"] = passedUsername
            tfriends["requestedFriend"] = ""
            tfriends.saveInBackground()
        } else if addUserButton.titleLabel?.text ==  "Accept Request" {
            let query = PFQuery(className: "FriendRequests")
            query.whereKey("requestingUser", equalTo: passedUsername)
            query.whereKey("pendingRequestUser", equalTo: (PFUser.current()?.username!)!)
            query.findObjectsInBackground(block: { (objects, error) in
                for object in objects! {
                    object.deleteInBackground()
                }
            })
            
            let mfriends = PFObject(className: "FriendRequests")
            mfriends["requestingUser"] = PFUser.current()?.username
            mfriends["requestedFriend"] = passedUsername
            mfriends.saveInBackground()
            
            let tfriends = PFObject(className: "FriendRequests")
            tfriends["requestingUser"] = passedUsername
            tfriends["requestedFriend"] = PFUser.current()?.username
            tfriends.saveInBackground()
        }
        _ = navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func reject_CancelUser(_ sender: Any) {
        if rejectUserButton.titleLabel?.text == "Cancel Friend Request" {
            let query = PFQuery(className: "FriendRequests")
            query.whereKey("requestingUser", equalTo: (PFUser.current()?.username!)!)
            query.whereKey("pendingRequestUser", equalTo: passedUsername)
            query.findObjectsInBackground(block: { (objects, error) in
                for object in objects! {
                    object.deleteInBackground()
                }
            })
            activeRequest = false
        } else if rejectUserButton.titleLabel?.text == "Reject Request" {
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
        _ = navigationController?.popToRootViewController(animated: true)
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        requestActive()
        
        if activeRequest {
            if !isFriend {
                rejectUserButton.isHidden = false
                addUserButton.frame.origin = CGPoint(x: 30, y: 410)
                rejectUserButton.frame.origin = CGPoint(x: 180, y: 410)
                addUserButton.setTitle("Accept Request", for: [])
            } else {
                rejectUserButton.isHidden = true
                addUserButton.frame.origin = CGPoint(x: (view.frame.size.width - 180) / 2, y: 410)
            }
        } else if !activeRequest {
            if isFriend {
                addUserButton.isHidden = true
                rejectUserButton.isHidden = true
            }
            rejectUserButton.isHidden = true
            addUserButton.frame.origin = CGPoint(x: (view.frame.size.width - 180) / 2, y: 410)
        }
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "messagesSegue" {
            let messageController = segue.destination as! MessageViewController
            messageController.user2 = passedUsername
        }
    }

}
