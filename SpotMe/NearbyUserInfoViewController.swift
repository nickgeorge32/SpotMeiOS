//
//  NearbyUserInfoViewController.swift
//  SpotMe
//
//  Created by Nicholas George on 3/23/17.
//  Copyright © 2017 Nicholas George. All rights reserved.
//

//TODO: Get user info
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
    var buttonText = "Add Friend"
    
    var activeRequest = false
    var isFriend = false

    
    func requestActive() {
        
    }
    
    @IBAction func add_AcceptUser(_ sender: Any) {
        if addUserButton.titleLabel?.text == "Add Friend" {
            
        } else if addUserButton.titleLabel?.text ==  "Accept Request" {
        
        }
        _ = navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func reject_CancelUser(_ sender: Any) {
        if rejectUserButton.titleLabel?.text == "Cancel Friend Request" {
        
            activeRequest = false
        } else if rejectUserButton.titleLabel?.text == "Reject Request" {
            
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
