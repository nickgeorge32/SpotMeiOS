//
//  HomeViewController.swift
//  SpotMe
//
//  Created by Nicholas George on 3/19/17.
//  Copyright © 2017 Nicholas George. All rights reserved.
//

import UIKit
import Firebase

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPopoverPresentationControllerDelegate {
    var friends = [String]()
    var posts = [String]()
    var messages = [String]()
    var refresher: UIRefreshControl!
    var token = ""
    
    @IBOutlet var tableView: UITableView!

    @objc func refresh() {
        friends.removeAll()
        posts.removeAll()
        messages.removeAll()
        //imageFiles.removeAll()
        
        loadPosts()
    }
    
    @IBAction func logout(_ sender: Any) {
        navigationController?.isNavigationBarHidden = true
        tabBarController?.tabBar.isHidden = true
        do {
            try Auth.auth().signOut()
        } catch {
            print("error signing out")
        }
        performSegue(withIdentifier: "logoutSegue", sender: self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        refresher = UIRefreshControl()
        refresher.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refresher.addTarget(self, action: #selector(refresh), for: UIControlEvents.valueChanged)
        tableView.addSubview(refresher)
        
        NotificationCenter.default.addObserver(self, selector: #selector(refresh), name:NSNotification.Name(rawValue: "NotificationID"), object: nil)
        
        self.tabBarController?.customizableViewControllers = nil
        
    }
    
    
    func displayAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        PFSession.getCurrentSessionInBackground { (session, error) in
//            if error != nil {
//                self.displayAlert(title: "Invalid Session", message: "You have been logged out, please log back in")
//            }
//        }
        
        pendingFriendRequestCheck()
        refresh()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if token.isEmpty {
            
        } else {
//            PFUser.current()?["fcmReg"] = token
//            PFUser.current()?.saveInBackground(block: { (success, error) in
//                if error != nil {
//                    var errorMessage = "Unable to save details"
//                    if let parseError = (error!as NSError).userInfo["error"] as? String {
//                        errorMessage = parseError
//                        self.displayAlert(title: "Error", message: errorMessage)
//                    }
//                }
//            })
        }
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4// posts.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! FeedTableViewCell
        
//        imageFiles[indexPath.row].getDataInBackground { (data, error) in
//            if let imageData = data {
//                if let downloadedImage = UIImage(data: imageData) {
//                    cell.profileImage.image = downloadedImage
//                }
//            }
        
//        }
        
        cell.username.text = "Username"//posts[indexPath.row]
        cell.postText.text = "Message"//messages[indexPath.row]
        
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
    
    //TODO: Add like and comment
    func loadPosts() {
//        let query = PFQuery(className: "Friends")
//        query.includeKey("requestingUser")
//        query.includeKey("friend")
//        
//        query.findObjectsInBackground { (objects, error) in
//            if(error == nil) {
//                if let object = objects {
//                    for friend in object {
//                        if let requestingPointer:PFObject = friend["requestingUser"] as? PFObject {
//                            if requestingPointer["username"] as? String == PFUser.current()?.username {
//                                    self.friends.append(String(describing: ((friend["friend"] as! PFUser).username)!))
//                            }
//                        }
//                    }
//                } else {
//                    print(error!)
//                }
//            }
//        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
//            let postsQuery = PFQuery(className: "Posts")
//            postsQuery.includeKey("username")
//
//            postsQuery.findObjectsInBackground { (objects, error) in
//                if error == nil && objects != nil {
//                    if (objects?.count)! > 0 {
//                        for users in objects! {
//                            if let pointer: PFObject = users["username"] as? PFObject {
//                                if pointer["username"] as? String == PFUser.current()?.username || self.friends.contains(pointer["username"] as! String)   {
//                                    self.posts.append(String(describing: ((users["username"] as! PFUser).username)!))
//                                    self.messages.append(String(describing: (users["postText"])!))
//                                    self.imageFiles.append(pointer["photo"] as! PFFile)
//                                }
//                            }
//
//                            self.refresher.endRefreshing()
//
//                            self.tableView.reloadData()
//                        }
//                    } else {
//                        print("error is \(String(describing: error))")
//                    }
//                }
//            }
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
        return UIModalPresentationStyle.none
    }

}
