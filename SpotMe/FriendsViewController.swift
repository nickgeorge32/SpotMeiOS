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
        pendingRequests.removeAll()
        friendsArray.removeAll()
        
        pendingFriendRequestCheck()
        friendsCheck()
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
    
    func pendingFriendRequestCheck() {
        var badgeValue = 0
        let query = PFQuery(className: "FriendRequests")
        query.whereKey("pendingRequestUser", equalTo: (PFUser.current()?.username!)!)
        query.findObjectsInBackground { (objects, error) in
            if let users = objects {
                for object in users {
                    if let user = object as? PFObject {
                        badgeValue += 1
                        self.tabBarController?.tabBar.items?[4].badgeValue = String(badgeValue)
                        self.pendingRequests.append(String(describing: (user["requestingUser"])!) + " (Pending)")
                        self.friendsArray.append(contentsOf: self.pendingRequests)
                    }
                }
            }
            self.tableView.reloadData()
        }
    }
    
    func friendsCheck() {
        let query = PFQuery(className: "FriendRequests")
        query.whereKey("requestingUser", equalTo: (PFUser.current()?.username!)!)
        query.findObjectsInBackground { (objects, error) in
            if let users = objects {
                for object in users {
                    if let user = object as? PFObject {
                        self.friendsArray.append(String(describing: (user["requestedFriend"])!))
                        print("friends array is \(self.friendsArray)")
                        self.friendsArray = self.friendsArray.filter(){$0 != ""}
                        print("friends array is \(self.friendsArray)")
                    }
                }
            }
            self.tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let indexPath = tableView.indexPathForSelectedRow
        let currentCell = tableView.cellForRow(at: indexPath!)! as UITableViewCell
        
        let showRequestingUserInfo = storyboard?.instantiateViewController(withIdentifier: "NearbyUserInfo") as! NearbyUserInfoViewController
        showRequestingUserInfo.passedUsername = (currentCell.textLabel?.text)!
        showRequestingUserInfo.buttonText = "Accept Request"

        navigationController?.pushViewController(showRequestingUserInfo, animated: true)


        
    }
}
