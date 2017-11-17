//
//  ButtonBorder.swift
//  SpotMe
//
//  Created by Nick George on 11/16/17.
//  Copyright © 2017 Nicholas George. All rights reserved.
//

import UIKit

@IBDesignable
class LoginButton: UIButton {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        customizeView()
    }
    
    override func prepareForInterfaceBuilder() {
        customizeView()
    }
    
    func customizeView() {
        backgroundColor = #colorLiteral(red: 0.3176470588, green: 0.7764705882, blue: 0.9098039216, alpha: 1)
        layer.cornerRadius = 8.0
        setTitleColor(#colorLiteral(red: 0.9333333333, green: 0.9333333333, blue: 0.9333333333, alpha: 1), for: .normal)
    }
}

@IBDesignable
class SignUpButton: UIButton {
    override func awakeFromNib() {
        super.awakeFromNib()
        
        customizeView()
    }
    
    override func prepareForInterfaceBuilder() {
        customizeView()
    }
    
    func customizeView() {
        backgroundColor = #colorLiteral(red: 1, green: 0.5098039216, blue: 0.007843137255, alpha: 1)
        layer.cornerRadius = 8.0
        setTitleColor(#colorLiteral(red: 0.9333333333, green: 0.9333333333, blue: 0.9333333333, alpha: 1), for: .normal)
    }
}
