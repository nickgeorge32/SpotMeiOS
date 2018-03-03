//
//  T&D_Portal.swift
//  SpotMe
//
//  Created by Nick George on 1/23/18.
//  Copyright © 2018 Nicholas George. All rights reserved.
//

import UIKit

class T_D_Portal: UIViewController {
    @IBOutlet weak var spotMeLogoText: UILabel!
    let logoBlue = UIColor(red: 81/255, green: 198/255, blue: 232/255, alpha: 1)
    let logoOrange = UIColor(red: 1, green: 130/255, blue: 2/255, alpha: 1)
    var myMutableString = NSMutableAttributedString()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }

    @IBAction func closeBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func setupView() {
        myMutableString = NSMutableAttributedString(string: spotMeLogoText.text!, attributes: [NSAttributedStringKey.font:UIFont(name: "AvenirNext-Heavy", size: 64.0)!])
        myMutableString.addAttribute(NSAttributedStringKey.foregroundColor, value: logoBlue, range: NSRange(location:0,length:4))
        myMutableString.addAttribute(NSAttributedStringKey.foregroundColor, value: logoOrange, range: NSRange(location:4,length:2))
        // set label Attribute
        spotMeLogoText.attributedText = myMutableString
    }
}
