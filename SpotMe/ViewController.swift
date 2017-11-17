//
//  ViewController.swift
//  SpotMe
//
//  Created by Nicholas George on 3/18/17.
//  Copyright © 2017 Nicholas George. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    //MARK: Outlets and Variables
    let logoBlue = UIColor(red: 81/255, green: 198/255, blue: 232/255, alpha: 1)
    let logoOrange = UIColor(red: 1, green: 130/255, blue: 2/255, alpha: 1)
    var myMutableString = NSMutableAttributedString()
    var index = 0
    var titleText: String!
    var detailsText: String!
    var bgImageName: String!
    
    @IBOutlet weak var spotMeLogoText: UILabel!
    @IBOutlet weak var pageTitleLabel: UILabel!
    @IBOutlet weak var pageDetailsLabel: UILabel!
    @IBOutlet weak var bgImageView: UIImageView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    @IBAction func loginButton(_ sender: Any) {
        performSegue(withIdentifier: "authSegue", sender: self)
    }
    
    @IBAction func signUpButton(_ sender: Any) {
        performSegue(withIdentifier: "authSegue", sender: self)
    }
    
    @IBAction func unwindFromAuthVC(unwindSegue: UIStoryboardSegue) {
        
    }
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myMutableString = NSMutableAttributedString(string: spotMeLogoText.text!, attributes: [NSAttributedStringKey.font:UIFont(name: "AvenirNext-Heavy", size: 64.0)!])
        myMutableString.addAttribute(NSAttributedStringKey.foregroundColor, value: logoBlue, range: NSRange(location:0,length:4))
        myMutableString.addAttribute(NSAttributedStringKey.foregroundColor, value: logoOrange, range: NSRange(location:4,length:2))
        // set label Attribute
        spotMeLogoText.attributedText = myMutableString
        
        pageTitleLabel.text = titleText
        pageDetailsLabel.text = detailsText
        bgImageView.image = UIImage(named: bgImageName)
        
        pageControl.currentPage = index
    }
    
    override func viewDidAppear(_ animated: Bool) {

    }
}
