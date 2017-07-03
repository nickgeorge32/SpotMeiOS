//
//  FriendsTableViewController.swift
//  SpotMe
//
//  Created by Nicholas George on 4/4/17.
//  Copyright © 2017 Nicholas George. All rights reserved.
//

import UIKit
import Parse

class FriendsTableViewController: UITableViewController {
    var pendingRequestsArray = [String]()
    var friendsArray = [String]()
    var refresher: UIRefreshControl!
    var isFriend = [Bool]()
    var pendingRequest = false
    
    func refresh() {
        friendsArray.removeAll()
        isFriend.removeAll()
        pendingRequestsArray.removeAll()
        
        pendingFriendRequestCheck()
        
        friendCheck()
    }
    
    func pendingFriendRequestCheck() {
        var badgeValue = 0
        
        pendingRequestsArray.removeAll()

        let query = PFQuery(className: "FriendRequests")
        query.whereKey("pendingRequestUser", equalTo: (PFUser.current()?.username!)!)
        query.findObjectsInBackground { (objects, error) in
            if error == nil && objects != nil {
                if (objects?.count)! > 0 {
                    if let users = objects {
                        for object in users {
                            if let user = object as? PFObject {
                                badgeValue += 1
                                
                                self.pendingRequestsArray.append(String(describing: (user["requestingUser"])!) + " (Pending)")
                                self.isFriend.append(false)
                                
                                self.tabBarController?.tabBar.items?[4].badgeValue = String(badgeValue)
                                
                                self.refresher.endRefreshing()
                            }
                        }
                    }
                } else {
                    self.tabBarController?.tabBar.items?[4].badgeValue = nil
                    self.refresher.endRefreshing()
                }
                self.friendsArray.append(contentsOf: self.pendingRequestsArray)
                self.tableView.reloadData()
            }
        }

    }
    
    func friendCheck() {
        let query = PFQuery(className: "FriendRequests")
        query.whereKey("requestingUser", equalTo: (PFUser.current()?.username!)!)
        query.findObjectsInBackground { (objects, error) in
            if let users = objects {
                for object in users {
                    if let user = object as? PFObject {
                        if user != nil {
                            self.friendsArray.append(String(describing: (user["requestedFriend"])!))
                            self.isFriend.append(true)
                            self.friendsArray = self.friendsArray.filter(){$0 != ""}
                        }
                    }
                }
                self.tableView.reloadData()
            }
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = false
        refresh()
        
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        refresher = UIRefreshControl()
        refresher.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refresher.addTarget(self, action: #selector(FriendsTableViewController.refresh), for: UIControlEvents.valueChanged)
        tableView.addSubview(refresher)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return friendsArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        cell.textLabel?.text = friendsArray[indexPath.row]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let indexPath = tableView.indexPathForSelectedRow
        let currentCell = tableView.cellForRow(at: indexPath!)! as UITableViewCell
        
        let showRequestingUserInfo = storyboard?.instantiateViewController(withIdentifier: "NearbyUserInfo") as! NearbyUserInfoViewController
        showRequestingUserInfo.passedUsername = (currentCell.textLabel?.text)!.components(separatedBy: " ")[0]
        
        if isFriend[(indexPath?.row)!] == true {
            showRequestingUserInfo.isFriend = true
            showRequestingUserInfo.activeRequest = false
        } else {
            showRequestingUserInfo.activeRequest = true
            showRequestingUserInfo.isFriend = false
        }
        
        navigationController?.pushViewController(showRequestingUserInfo, animated: true)

    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
