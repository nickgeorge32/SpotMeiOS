//
//  NearbyUserInfoViewController.swift
//  SpotMe
//
//  Created by Nicholas George on 3/23/17.
//  Copyright © 2017 Nicholas George. All rights reserved.
//

import UIKit

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
        //MARK: changed to pointers 0.3.0
//        let query = PFQuery(className: "FriendRequests")
//        query.includeKey("requestingUser")
//        query.includeKey("pendingFriendRequest")
//
//        query.findObjectsInBackground { (objects, error) in
//            if (error == nil) {
//                if let users = objects {
//                    for object in users {
//                        if let requestingUserPointer: PFObject = object["requestingUser"] as? PFObject{
//                            if let requestedFriend: PFObject = object["pendingFriendRequest"] as? PFObject{
//                                if requestingUserPointer["username"] as? String == PFUser.current()?.username && requestedFriend["username"] as? String == self.passedUsername {
//                                    print("activeRequest")
//                                self.addUserButton.isHidden = true
//                                self.rejectUserButton.isHidden = false
//                                self.rejectUserButton.frame.origin = CGPoint(x: (self.view.frame.size.width - 180) / 2, y: 410)
//                                self.rejectUserButton.setTitle("Cancel Friend Request", for: [])
//                                self.activeRequest = true
//                                }
//                            }
//                        }
//                    }
//                }
//            }
//        }
    }
    
    //FIXME: change queries to reflect pointers
    
    @IBAction func add_AcceptUser(_ sender: Any) {
        if addUserButton.titleLabel?.text == "Add Friend" {
//            let pointer = PFObject(withoutDataWithClassName: "_User", objectId: PFUser.current()?.objectId)
//            let query = PFUser.query()
//            query?.whereKey("username", equalTo: passedUsername)
//            query?.getFirstObjectInBackground(block: { (user, error) in
//                if error == nil {
//                    self.passedId = (user?.objectId)!
//                }
//            })
//            let pointer2 = PFObject(withoutDataWithClassName: "_User", objectId: passedId)
//
//            let tfriends = PFObject(className: "FriendRequests")
//            tfriends["requestingUser"] = pointer
//            tfriends["pendingRequestUser"] = pointer2
//            tfriends.saveInBackground()
//        } else if addUserButton.titleLabel?.text ==  "Accept Request" {
//            let query = PFQuery(className: "FriendRequests")
//            query.includeKey("requestingUser")
//            query.includeKey("pendingFriendRequest")
//            query.findObjectsInBackground(block: { (objects, error) in
//                for object in objects! {
//                    if let requestingUserPointer: PFObject = object["requestingUser"] as? PFObject {
//                        if let requestedUser: PFObject = object["pendingFriendRequest"] as? PFObject {
//                            if requestingUserPointer["username"] as? String == self.passedUsername && requestedUser["username"] as? String == PFUser.current()?.username {
//                                object.deleteInBackground()
//                            }
//                        }
//                    }
//                }
//            })
//
//            let pointer = PFObject(withoutDataWithClassName: "_User", objectId: PFUser.current()?.objectId)
//            let query2 = PFUser.query()
//            query2?.whereKey("username", equalTo: passedUsername)
//            query2?.getFirstObjectInBackground(block: { (user, error) in
//                if error == nil {
//                    self.passedId = (user?.objectId)!
//                }
//            })
//            let pointer2 = PFObject(withoutDataWithClassName: "_User", objectId: passedId)
//
//            let mfriends = PFObject(className: "Friends")
//            mfriends["requestingUser"] = pointer
//            mfriends["friend"] = pointer2
//            mfriends.saveInBackground()
//
//            let tfriends = PFObject(className: "Friends")
//            tfriends["requestingUser"] = pointer2
//            tfriends["friend"] = pointer
//            tfriends.saveInBackground()
        }
        _ = navigationController?.popToRootViewController(animated: true)
    }
    
    //MARK: fixed in 0.3.0
    @IBAction func reject_CancelUser(_ sender: Any) {
        if rejectUserButton.titleLabel?.text == "Cancel Friend Request" {
//            let query = PFQuery(className: "FriendRequests")
//            query.includeKey("requestingUser")
//            query.includeKey("pendingFriendRequest")
//            query.findObjectsInBackground(block: { (objects, error) in
//                for object in objects! {
//                    if let requestingPointer: PFObject = object["requestingUser"] as? PFObject {
//                        if let requestedUserPointer: PFObject = object["pendingFriendRequest"] as? PFObject{
//                            if requestingPointer["username"] as? String == PFUser.current()?.username && requestedUserPointer["username"] as? String == self.passedUsername {
//                                object.deleteInBackground()
//                            }
//                        }
//                    }
//                }
//            })
//            activeRequest = false
//        } else if rejectUserButton.titleLabel?.text == "Reject Request" {
//            let query = PFQuery(className: "FriendRequests")
//            query.includeKey("requestingUser")
//            query.includeKey("pendingFriendRequest")
//            query.findObjectsInBackground(block: { (objects, error) in
//                for object in objects! {
//                    if let requestingPointer: PFObject = object["requestingUser"] as? PFObject {
//                        if let requestedUserPointer: PFObject = object["pendingFriendRequest"] as? PFObject{
//                            if requestingPointer["username"] as? String == self.passedUsername && requestedUserPointer["username"] as? String == PFUser.current()?.username {
//                                object.deleteInBackground()
//                            }
//                        }
//                    }
//                }
//            })
//            activeRequest = false
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
        
//        let query = PFUser.query()
//        query?.whereKey("username", equalTo: username.text!)
//        query?.findObjectsInBackground(block: { (objects, error) in
//            if let users = objects {
//                for object in users {
//                    if let user = object as? PFUser {
//                        self.gender.text = object["gender"] as! String?
//                        self.weightGoal.text = object["weightGoal"] as! String?
//                        self.desiredOutcome.text = object["desiredOutcome"] as! String?
//                        let imageFile = user["photo"] as! PFFile
//                        imageFile.getDataInBackground(block: { (data, error) in
//                            if let imageData = data {
//                                self.userProfileImage.image = UIImage(data: imageData)
//                            }
//                        })
//                    }
//                }
//                
//            }
//        })
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "messagesSegue" {
            let messageController = segue.destination as! MessageViewController
            messageController.user2 = passedUsername
        }
    }
    
}

