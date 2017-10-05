//
//  ShopViewController.swift
//  SpotMe
//
//  Created by Nicholas George on 10/5/17.
//  Copyright © 2017 Nicholas George. All rights reserved.
//

import UIKit
import Parse

class ShopViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func pendingFriendRequestCheck() {
        var badgeValue = 0
        
        let query = PFQuery(className: "FriendRequests")
        query.includeKey("requestingUser")
        query.includeKey("pendingFriendRequest")
        
        query.findObjectsInBackground { (objects, error) in
            if error == nil && objects != nil {
                if (objects?.count)! > 0 {
                    if let users = objects {
                        for object in users {
                            if let requestedPointer:PFObject = object["pendingFriendRequest"] as? PFObject {
                                if requestedPointer["username"] as? String == PFUser.current()?.username {
                                    badgeValue += 1
                                    
                                    self.tabBarController?.tabBar.items?[4].badgeValue = String(badgeValue)
                                    
                                }
                            }
                        }
                    }
                } else {
                    self.tabBarController?.tabBar.items?[4].badgeValue = nil
                }
            }
        }
        
    }
}
