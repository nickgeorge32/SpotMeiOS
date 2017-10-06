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
    
    @objc func refresh() {
        events.removeAll()
        
        loadEvents()
    }
    
    func displayAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        let contactAction = UIAlertAction(title: "Contact", style: .default) { UIAlertAction in
            let settingsVC = self.storyboard?.instantiateViewController(withIdentifier: "Settings") as! SettingsTableViewController
            //self.present(settingsVC, animated: true, completion:nil)
            self.navigationController?.pushViewController(settingsVC, animated: true)
        }
        alertController.addAction(contactAction)
        self.present(alertController, animated: true, completion: nil)
    }

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
    @IBAction func addEvent(_ sender: Any) {
        displayAlert(title: "Coming Soon", message: "We currently do not support adding events via the app at this time. We are working diligently to make this available to all. If you would like to submit your event to us by email, we will add it to the app within 24hrs.")
    }

    
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as UITableViewCell
        cell.textLabel?.text = events[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let indexPath = tableView.indexPathForSelectedRow
        let currentCell = tableView.cellForRow(at: indexPath!)! as UITableViewCell
        
        let showEventDetails = storyboard?.instantiateViewController(withIdentifier: "EventDetails") as! EventDetailsViewController
        showEventDetails.eventTitleString = (currentCell.textLabel?.text)!
        
        navigationController?.pushViewController(showEventDetails, animated: true)
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
                                    
                                    self.tabBarController?.tabBar.items?[3].badgeValue = String(badgeValue)
                                    
                                }
                            }
                        }
                    }
                } else {
                    self.tabBarController?.tabBar.items?[3].badgeValue = nil
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
                        self.events.append(String(describing: (event["title"])!))
                        self.refresher.endRefreshing()
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }
}

