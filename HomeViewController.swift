//
//  HomeViewController.swift
//  SpotMe
//
//  Created by Nicholas George on 3/19/17.
//  Copyright © 2017 Nicholas George. All rights reserved.
//

import UIKit
import Parse
import FirebaseMessaging

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var friends = [String]()
    var posts = [String]()
    var messages = [String]()
    var refresher: UIRefreshControl!
    var imageFiles = [PFFile]()
    
    
    @IBOutlet var tableView: UITableView!

    func refresh() {
        friends.removeAll()
        posts.removeAll()
        messages.removeAll()
        imageFiles.removeAll()
        
        loadPosts()
    }
    
    @IBAction func logout(_ sender: Any) {
        PFUser.logOut()
        performSegue(withIdentifier: "logoutSegue", sender: self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        refresher = UIRefreshControl()
        refresher.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refresher.addTarget(self, action: #selector(HomeViewController.refresh), for: UIControlEvents.valueChanged)
        tableView.addSubview(refresher)
    }
    
    
    func displayAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
            UIAlertAction in
            self.performSegue(withIdentifier: "logoutSegue", sender: self)
            PFUser.logOut()
        }
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        PFSession.getCurrentSessionInBackground { (session, error) in
            if error != nil {
                self.displayAlert(title: "Invalid Session", message: "You have been logged out, please log back in")
            }
        }
        
        pendingFriendRequestCheck()
        refresh()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //pendingFriendRequestCheck()
        
        if let url = URL(string: "https://fcm.googleapis.com/fcm/send") {
            var request = URLRequest(url: url)
            request.allHTTPHeaderFields = ["Content-Type":"application/json","Authorization":"key=AAAAmxg0AHY:APA91bEV7GykrT5Z59-WElvzB826NQzYMU21oUn0WFd7JZvE1mC-1wQ9i5J-YR2zYqwhmw-vCVUtGEgzsMENIsKEiUsJ2-xDo_wP_AxGjRK3mcVT7w6ePZf_hpp4eGyX8rZ7cjatrCCo"]
            request.httpMethod = "POST"
            request.httpBody = "{\"to\":\"eGreWn9lBfY:APA91bE_V18bqxfScAcvuYSFNtylpuS39WQmVljnHbhGRCzUBXuoigSBGTFglvPUps5CAE_BmKxuMwtUM8sJKECiyRSrkkxfSIYMWmUAfkUm9v9fmFTIWuSAKbul7MbyZ1AJsuHkPK9k\",\"notification\":{\"body\":\"THIS IS FROM HTTP!\"}}".data(using: .utf8)
            
            URLSession.shared.dataTask(with: request, completionHandler: { (data, urlresponse, error) in
                if error != nil {
                    print(error!)
                }
                print(String(data: data!, encoding: .utf8)!)
            }).resume()
        }
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! FeedTableViewCell
        
        imageFiles[indexPath.row].getDataInBackground { (data, error) in
            if let imageData = data {
                if let downloadedImage = UIImage(data: imageData) {
                    cell.profileImage.image = downloadedImage
                }
            }
            
        }
        
        cell.username.text = posts[indexPath.row]
        cell.postText.text = messages[indexPath.row]
        
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
    
    func loadPosts() {
            let query = PFQuery(className: "FriendRequests")
            query.whereKey("requestingUser", equalTo: (PFUser.current()?.username!)!)
            query.findObjectsInBackground { (objects, error) in
                if let users = objects {
                    for object in users {
                        if let user = object as? PFObject {
                            if user != nil {
                                self.friends.append(String(describing: (user["requestedFriend"])!))
                                self.friends = self.friends.filter(){$0 != ""}

                            }
                        }
                    }
                }
            }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
            let postsQuery = PFQuery(className: "Posts")
            postsQuery.whereKey("user", containedIn: self.friends as [AnyObject])
            postsQuery.findObjectsInBackground { (objects, error) in
                if error == nil && objects != nil {
                    if (objects?.count)! > 0 {
                        for users in objects! {
                            self.posts.append(String(describing: (users["user"])!))
                            self.messages.append(String(describing: (users["postText"])!))
                            self.imageFiles.append(users["profileImage"] as! PFFile)
                            
                            self.refresher.endRefreshing()
                            
                            self.tableView.reloadData()
                        }
                    } else {
                        print("error is \(error)")
                    }
                }
            }
        }
    }

}
