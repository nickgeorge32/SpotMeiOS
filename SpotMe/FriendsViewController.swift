//
//  FriendsViewController.swift
//  SpotMe
//
//  Created by Nicholas George on 3/21/17.
//  Copyright © 2017 Nicholas George. All rights reserved.
//

import UIKit
import Parse

class FriendsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var tableView: UITableView!
    var pendingRequests = [String]()
    var friendsArray = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        pendingFriendRequestCheck()
                
        //friendsCheck()
        
        print("pending 2 \(pendingRequests)")
        print("friends 2 \(friendsArray)")
    }
    
    func pendingFriendRequestCheck() {
        //var badgeValue = 0
        let query = PFQuery(className: "FriendRequests")
        query.whereKey("pendingRequestUser", equalTo: (PFUser.current()?.username!)!)
        query.findObjectsInBackground { (objects, error) in
            if error == nil && objects != nil {
                if let users = objects {
                    for object in users {
                        if let user = object as? PFObject {
                                self.pendingRequests.append(String(describing: (user["requestingUser"])!) + " (Pending)")
                            }
                        }
                    }
                } else {
                    self.tabBarController?.tabBar.items?[4].badgeValue = nil
                }
            self.tableView.reloadData()
            }
        friendsArray.append(contentsOf: pendingRequests)
    }
    
    func friendsCheck() {
        let query = PFQuery(className: "FriendRequests")
        query.whereKey("requestingUser", equalTo: (PFUser.current()?.username!)!)
        query.findObjectsInBackground { (objects, error) in
            if let users = objects {
                for object in users {
                    if let user = object as? PFObject {
                        self.friendsArray.append(String(describing: (user["requestedFriend"])!))
                        self.friendsArray = self.friendsArray.filter(){$0 != ""}
                    }
                }
            }
            self.tableView.reloadData()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friendsArray.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "Cell")
        
        cell.textLabel?.text = friendsArray[indexPath.row]
        
        return cell
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let indexPath = tableView.indexPathForSelectedRow
        let currentCell = tableView.cellForRow(at: indexPath!)! as UITableViewCell
        
        let showRequestingUserInfo = storyboard?.instantiateViewController(withIdentifier: "NearbyUserInfo") as! NearbyUserInfoViewController
        showRequestingUserInfo.passedUsername = (currentCell.textLabel?.text)!.components(separatedBy: " ")[0]
        showRequestingUserInfo.buttonText = "Accept Request"
        showRequestingUserInfo.requestMode = false

        navigationController?.pushViewController(showRequestingUserInfo, animated: true)
        
    }
}
