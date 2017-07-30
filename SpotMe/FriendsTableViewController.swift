//
//  FriendsTableViewController.swift
//  SpotMe
//
//  Created by Nicholas George on 4/4/17.
//  Copyright © 2017 Nicholas George. All rights reserved.
//

import UIKit

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

        
    }
    
    func friendCheck() {
        
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
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
}
