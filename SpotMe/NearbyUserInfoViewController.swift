//
//  NearbyUserInfoViewController.swift
//  SpotMe
//
//  Created by Nicholas George on 3/23/17.
//  Copyright © 2017 Nicholas George. All rights reserved.
//

import UIKit
import Parse

class NearbyUserInfoViewController: UIViewController {
    @IBOutlet var userProfileImage: UIImageView!
    @IBOutlet var username: UILabel!
    @IBOutlet var addUser: UIButton!
    
    var passedUsername = ""

    @IBAction func friendUser(_ sender: Any) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = false
        username.text = passedUsername
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
