//
//  EventsViewController.swift
//  SpotMe
//
//  Created by Nicholas George on 3/21/17.
//  Copyright © 2017 Nicholas George. All rights reserved.
//

import UIKit
import Parse

class EventsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var events = [String]()
    var refresher: UIRefreshControl!
    
    @IBOutlet var tableView: UITableView!
    
    func refresh() {
        events.removeAll()
        
        loadEvents()
    }
    
//    func displayAlert(title: String, message: String) {
//        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
//        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
//            UIAlertAction in
//            self.tabBarController?.selectedIndex = 2
//        }
//        alertController.addAction(okAction)
//        self.present(alertController, animated: true, completion: nil)
//    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        refresher = UIRefreshControl()
        refresher.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refresher.addTarget(self, action: #selector(EventsViewController.refresh), for: UIControlEvents.valueChanged)
        tableView.addSubview(refresher)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        refresh()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        pendingFriendRequestCheck()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as UITableViewCell
        cell.textLabel?.text = events[indexPath.row]
        
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
    
    func loadEvents() {
        let eventsQuery = PFQuery(className: "Events")
        eventsQuery.findObjectsInBackground { (objects, error) in
            if let events = objects {
                for object in events {
                    if let event = object as? PFObject {
                        self.events.append(String(describing: (event["Title"])!))
                        self.refresher.endRefreshing()
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }
}
