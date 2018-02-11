//
//  ActivityViewController.swift
//  SpotMe
//
//  Created by Nicholas George on 3/21/17.
//  Copyright © 2017 Nicholas George. All rights reserved.
//

import UIKit

class ActivityViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //    func displayAlert(title: String, message: String) {
    //        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
    //        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
    //            UIAlertAction in
    //            self.tabBarController?.selectedIndex = 2
    //        }
    //        alertController.addAction(okAction)
    //        self.present(alertController, animated: true, completion: nil)
    //    }
    
    override func viewWillAppear(_ animated: Bool) {
        //        let query = PFQuery(className: "Activities")
        //        query.whereKeyExists("username")
        //        query.findObjectsInBackground { (objects, error) in
        //            if error == nil && objects != nil {
        //                if (objects?.count)! == 0 {
        //
        //                }
        //            }
        //        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //pendingFriendRequestCheck()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        var numOfSections: Int = 0
        let noDataLabel: UILabel     = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
        noDataLabel.text          = "No data available"
        noDataLabel.textColor     = UIColor.black
        noDataLabel.textAlignment = .center
        tableView.backgroundView  = noDataLabel
        tableView.separatorStyle  = .none
        
        return numOfSections
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return 4
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "Cell")
        cell.textLabel?.text = "Test"
        
        return cell
    }
    
    func pendingFriendRequestCheck() {
        var badgeValue = 0
        
        //        let query = PFQuery(className: "FriendRequests")
        //        query.includeKey("requestingUser")
        //        query.includeKey("pendingFriendRequest")
        //        
        //        query.findObjectsInBackground { (objects, error) in
        //            if error == nil && objects != nil {
        //                if (objects?.count)! > 0 {
        //                    if let users = objects {
        //                        for object in users {
        //                            if let requestedPointer:PFObject = object["pendingFriendRequest"] as? PFObject {
        //                                if requestedPointer["username"] as? String == PFUser.current()?.username {
        //                                    badgeValue += 1
        //                                    
        //                                    self.tabBarController?.tabBar.items?[3].badgeValue = String(badgeValue)
        //                                    
        //                                }
        //                            }
        //                        }
        //                    }
        //                } else {
        //                    self.tabBarController?.tabBar.items?[3].badgeValue = nil
        //                }
        //            }
        //        }
        
    }
    
}
