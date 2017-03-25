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

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        pendingRequests.removeAll()
        pendingFriendRequestCheck()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pendingRequests.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "Cell")
        cell.textLabel?.text = pendingRequests[indexPath.row]
        
        return cell
    }
    
    func pendingFriendRequestCheck() {
        var badgeValue = 0
        let query = PFQuery(className: "FriendRequests")
        query.whereKey("requestedUser", equalTo: (PFUser.current()?.username!)!)
        query.findObjectsInBackground { (objects, error) in
            if let users = objects {
                for object in users {
                    if let user = object as? PFObject {
                        badgeValue += 1
                        self.tabBarController?.tabBar.items?[4].badgeValue = String(badgeValue)
                        self.pendingRequests.append(user["requestingUser"] as! String)
                        print(self.pendingRequests)
                    }
                }
            }
            self.tableView.reloadData()
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
