//
//  LaunchVC.swift
//  SpotMe
//
//  Created by Nick George on 11/10/17.
//  Copyright © 2017 Nicholas George. All rights reserved.
//

import UIKit
import Firebase
import Reachability

class LaunchVC: UIViewController {
    //MARK: Outlets and Variables
    @IBOutlet weak var spotMeLabel: UILabel!
    @IBOutlet weak var locationImage: UIImageView!
    @IBOutlet weak var weightImg: UIImageView!
    @IBOutlet weak var runImg: UIImageView!
    @IBOutlet weak var cycleImg: UIImageView!
    @IBOutlet weak var hikeImg: UIImageView!
    
    let logoBlue = UIColor(red: 81/255, green: 198/255, blue: 232/255, alpha: 1)
    let logoOrange = UIColor(red: 1, green: 130/255, blue: 2/255, alpha: 1)
    var myMutableString = NSMutableAttributedString()
    
    var reachability = Reachability()!
    
    var accountType: String?
    
    //MARK: Lifecycle
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(LaunchVC.reachabilityChanged(note:)), name: .reachabilityChanged, object: reachability)
        do{
            try reachability.startNotifier()
        }catch{
            print("could not start reachability notifier")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        
        accountType = UserDefaults.standard.string(forKey: "accountType")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            UIView.animate(withDuration: 0.6, delay: 0, options: .curveLinear, animations: {
                self.locationImage.center.x = self.runImg.center.x + 15
            }, completion: nil)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            UIView.animate(withDuration: 0.6, delay: 0, options: .curveLinear, animations: {
                self.locationImage.center.x = self.cycleImg.center.x + 15
            }, completion: nil)        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            if self.reachability.connection != .none {
                    print("Reachable")
                    UIView.animate(withDuration: 0.6, delay: 0, options: .curveLinear, animations: {
                        self.locationImage.center.x = self.hikeImg.center.x + 15
                    }, completion: nil)
                }
            self.reachability.whenUnreachable = { _ in
                print("Not reachable")
            }
            
            do {
                try self.reachability.startNotifier()
            } catch {
                print("Unable to start notifier")
            }

        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.5) {
            if Auth.auth().currentUser == nil {
                self.performSegue(withIdentifier: "segueWelcomeVC", sender: nil)
            } else {
                if self.accountType == "user" {
                    self.performSegue(withIdentifier: "homeSegue", sender: nil)
                } else if self.accountType == "trainer" {
                    self.performSegue(withIdentifier: "homeSegue", sender: nil)
                } else if self.accountType == "distributor" {
                    self.performSegue(withIdentifier: "distributorSegue", sender: nil)
                }
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        reachability.stopNotifier()
        NotificationCenter.default.removeObserver(self, name: .reachabilityChanged, object: reachability)
    }
    
    //MARK: Misc
    func setupView() {
        myMutableString = NSMutableAttributedString(string: spotMeLabel.text!, attributes: [NSAttributedStringKey.font:UIFont(name: "AvenirNext-Heavy", size: 64.0)!])
        myMutableString.addAttribute(NSAttributedStringKey.foregroundColor, value: logoBlue, range: NSRange(location:0,length:4))
        myMutableString.addAttribute(NSAttributedStringKey.foregroundColor, value: logoOrange, range: NSRange(location:4,length:2))
        // set label Attribute
        spotMeLabel.attributedText = myMutableString
    }
    
    @objc func reachabilityChanged(note: Notification) {
        let reachability = note.object as! Reachability
        
        switch reachability.connection {
        case .wifi:
            print("Reachable via WiFi")
        case .cellular:
            print("Reachable via Cellular")
        case .none:
            print("Network not reachable")
        }
    }
}
