//
//  HomeViewController.swift
//  SpotMe
//
//  Created by Nicholas George on 3/19/17.
//  Copyright © 2017 Nicholas George. All rights reserved.
//

import UIKit
import Firebase

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet var tableView: UITableView!
    
    var friends = [String]()
    var posts = [String]()
    var messages = [String]()
    var refresher: UIRefreshControl!
    
    var dbRef:DatabaseReference!

    func refresh() {
        friends.removeAll()
        posts.removeAll()
        messages.removeAll()
        
        loadPosts()
    }
    
    @IBAction func logout(_ sender: Any) {
        try! Auth.auth().signOut()
        dbRef.removeAllObservers()
        performSegue(withIdentifier: "logoutSegue", sender: self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        dbRef = Database.database().reference()

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
        }
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        pendingFriendRequestCheck()
        refresh()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! FeedTableViewCell
        
        cell.username.text = posts[indexPath.row]
        cell.postText.text = messages[indexPath.row]
        
        return cell
    }
    
    func pendingFriendRequestCheck() {
        var badgeValue = 0
    }
    
    func loadPosts() {

        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
        
        }
        
    }

}
