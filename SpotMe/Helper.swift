//
//  Reachability.swift
//  SpotMe
//
//  Created by Nick George on 11/10/17.
//  Copyright © 2017 Nicholas George. All rights reserved.
//

import Foundation
import UIKit

class Helper {
    static let instance = Helper()
    
    //MARK: Display Alert
    func displayAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Dismiss", style: .default, handler: nil)
        alertController.addAction(okAction)
        UIApplication.topViewController()?.present(alertController, animated: true, completion: nil)
    }
}

extension UIApplication {
    
    static func topViewController(base: UIViewController? = UIApplication.shared.delegate?.window??.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController, let selected = tab.selectedViewController {
            return topViewController(base: selected)
        }
        if let presented = base?.presentedViewController {
            return topViewController(base: presented)
        }
        
        return base
    }
}
