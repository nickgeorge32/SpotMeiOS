//  PostViewController.swift
//  SpotMe
//
//  Created by Nick George on 9/10/17.
//  Copyright © 2017 Nicholas George. All rights reserved.
//

import UIKit
import Parse

class PostViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var postText: UITextView!
    
    @IBAction func postButton(_ sender: Any) {
        let pointer = PFObject(withoutDataWithClassName: "_User", objectId: PFUser.current()?.objectId)
        
        let posts = PFObject(className: "Posts")
        posts["postText"] = postText.text
        posts["username"] = pointer
        posts.saveInBackground()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.postText.delegate = self
        postText.layer.borderWidth = 1
        postText.text = "Enter Post"
        postText.textColor = UIColor.lightGray
        
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }

    func textViewDidChange(textView: UITextView) {
        
        let textViewFixedWidth: CGFloat = self.postText.frame.size.width

        let nSize: CGSize = self.postText.sizeThatFits(CGSize(width: textViewFixedWidth, height: CGFloat(MAXFLOAT)))
        var newFrame: CGRect = self.postText.frame
        
        var textViewYPosition = self.postText.frame.origin.y
        var heightDifference = self.postText.frame.height - nSize.height
        
        if (abs(heightDifference) > 20) {
            newFrame.size = CGSize(width: fmax(nSize.width, textViewFixedWidth), height: nSize.height)

            newFrame.offsetBy(dx: 0.0, dy: 0)
        }
        self.postText.frame = newFrame
        
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Enter Post"
            textView.textColor = UIColor.lightGray
        }
    }
    
}
