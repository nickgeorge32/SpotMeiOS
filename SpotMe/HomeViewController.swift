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

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPopoverPresentationControllerDelegate {
    var friends = [String]()
    var posts = [String]()
    var messages = [String]()
    var refresher: UIRefreshControl!
    var imageFiles = [PFFile]()
    var token = ""
    
    
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
        navigationController?.isNavigationBarHidden = true
        tabBarController?.tabBar.isHidden = true
        performSegue(withIdentifier: "logoutSegue", sender: self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        token = appDelegate.token

        // Do any additional setup after loading the view.
        refresher = UIRefreshControl()
        refresher.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refresher.addTarget(self, action: #selector(HomeViewController.refresh), for: UIControlEvents.valueChanged)
        tableView.addSubview(refresher)
        
    }
    
    
    func displayAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
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
        if token.isEmpty {
            
        } else {
            PFUser.current()?["fcmReg"] = token
            PFUser.current()?.saveInBackground(block: { (success, error) in
                if error != nil {
                    var errorMessage = "Unable to save details"
                    if let parseError = (error!as NSError).userInfo["error"] as? String {
                        errorMessage = parseError
                        self.displayAlert(title: "Error", message: errorMessage)
                    }
                } else {
                    self.displayAlert(title: "Success", message: "Profile Saved!")
                }
            })
        }
        
        //pendingFriendRequestCheck()
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
                    for _ in objects! {
                        badgeValue = (objects?.count)!
                        self.tabBarController?.tabBar.items?[4].badgeValue = String(badgeValue)
                    }
                } else {
                    self.tabBarController?.tabBar.items?[4].badgeValue = nil
                }
            }
        }
    }
    
    //TODO: Add like and comment
    func loadPosts() {
        let query = PFQuery(className: "FriendRequests")
        query.includeKey("requestingUser")
        query.includeKey("requestedFriend")
        
        query.findObjectsInBackground { (objects, error) in
            if(error == nil) {
                if let friend = objects {
                    for something in friend {
                        if let requestingPointer:PFObject = something["requestingUser"] as? PFObject {
                            if requestingPointer["username"] as? String == PFUser.current()?.username {
                                    self.friends.append(String(describing: ((something["requestedFriend"] as! PFUser).username)!))
                            }
                        }
                    }
                } else {
                    print(error!)
                }
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
            let postsQuery = PFQuery(className: "Posts")
            postsQuery.includeKey("username")
            
            postsQuery.findObjectsInBackground { (objects, error) in
                if error == nil && objects != nil {
                    if (objects?.count)! > 0 {
                        for users in objects! {
                            if let pointer: PFObject = users["username"] as? PFObject {
                                if pointer["username"] as? String == PFUser.current()?.username || self.friends.contains(pointer["username"] as! String)   {
                                    self.posts.append(String(describing: ((users["username"] as! PFUser).username)!))
                                    self.messages.append(String(describing: (users["postText"])!))
                                    self.imageFiles.append(pointer["photo"] as! PFFile)
                                }
                            }
                            
                            self.refresher.endRefreshing()
                            
                            self.tableView.reloadData()
                        }
                    } else {
                        print("error is \(String(describing: error))")
                    }
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "postSegue" {
            let popoverViewController = segue.destination
            popoverViewController.modalPresentationStyle = UIModalPresentationStyle.popover
            popoverViewController.popoverPresentationController!.delegate = self

        }
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        // return UIModalPresentationStyle.FullScreen
        return UIModalPresentationStyle.none
    }

}
