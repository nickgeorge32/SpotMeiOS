//
//  HomeViewController.swift
//  SpotMe
//
//  Created by Nicholas George on 3/19/17.
//  Copyright © 2017 Nicholas George. All rights reserved.
//

import UIKit
import Parse

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBAction func logout(_ sender: Any) {
        PFUser.logOut()
        performSegue(withIdentifier: "logoutSegue", sender: self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        pendingFriendRequestCheck()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "Cell")
        cell.textLabel?.text = "Test"
        
        return cell
    }
    
    func pendingFriendRequestCheck() {
        var badgeValue = 0
        let query = PFQuery(className: "FriendRequests")
        query.whereKey("pendingRequestUser", equalTo: (PFUser.current()?.username!)!)
        query.findObjectsInBackground { (objects, error) in
            if error == nil && objects != nil {
                if (objects?.count)! > 0 {
                    for users in objects! {
                        badgeValue = (objects?.count)!
                        self.tabBarController?.tabBar.items?[4].badgeValue = String(badgeValue)
                    }
                } else {
                    self.tabBarController?.tabBar.items?[4].badgeValue = nil
                }
            }
        }
    }

}
