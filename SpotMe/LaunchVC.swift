//
//  LaunchVC.swift
//  SpotMe
//
//  Created by Nick George on 11/10/17.
//  Copyright © 2017 Nicholas George. All rights reserved.
//

import UIKit
import Firebase

class LaunchVC: UIViewController {
    //MARK: Outlets and Variables
    @IBOutlet weak var spotMeLabel: UILabel!
    
    @IBOutlet weak var locationImage: UIImageView!
    let logoBlue = UIColor(red: 81/255, green: 198/255, blue: 232/255, alpha: 1)
    let logoOrange = UIColor(red: 1, green: 130/255, blue: 2/255, alpha: 1)
    var myMutableString = NSMutableAttributedString()
    
    @IBOutlet weak var weightImg: UIImageView!
    @IBOutlet weak var runImg: UIImageView!
    @IBOutlet weak var cycleImg: UIImageView!
    @IBOutlet weak var hikeImg: UIImageView!
    
    var handle: AuthStateDidChangeListenerHandle?
    let preferences = UserDefaults.standard
    
    //MARK: LIfecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myMutableString = NSMutableAttributedString(string: spotMeLabel.text!, attributes: [NSAttributedStringKey.font:UIFont(name: "AvenirNext-Heavy", size: 64.0)!])
        myMutableString.addAttribute(NSAttributedStringKey.foregroundColor, value: logoBlue, range: NSRange(location:0,length:4))
        myMutableString.addAttribute(NSAttributedStringKey.foregroundColor, value: logoOrange, range: NSRange(location:4,length:2))
        // set label Attribute
        spotMeLabel.attributedText = myMutableString
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveLinear, animations: {
                self.locationImage.center.x = self.runImg.center.x + 15
            }, completion: nil)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveLinear, animations: {
                self.locationImage.center.x = self.cycleImg.center.x + 15
            }, completion: nil)        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveLinear, animations: {
                self.locationImage.center.x = self.hikeImg.center.x + 15
            }, completion: nil)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.5) {
            if Helper.isInternetAvailable(){
                if self.isUserLoggedIn() {
                    self.performSegue(withIdentifier: "segueHome", sender: self)
                } else {
                    self.performSegue(withIdentifier: "welcomeVCSegue", sender: self)
                }
            }
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        Auth.auth().removeStateDidChangeListener(handle!)
    }
    
    //MARK: Misc
    func isUserLoggedIn()->Bool {
        handle = Auth.auth().addStateDidChangeListener({ (auth, user) in
            self.preferences.set(true, forKey: "isLoggedIn")
            self.preferences.synchronize()
        })
        return preferences.bool(forKey: "isLoggedIn")
    }
}
