//
//  FeedTableViewCell.swift
//  SpotMe
//
//  Created by Nicholas George on 7/2/17.
//  Copyright © 2017 Nicholas George. All rights reserved.
//

import UIKit

class FeedTableViewCell: UITableViewCell {

    @IBOutlet var username: UILabel!
    @IBOutlet var profileImage: UIImageView!
    @IBOutlet var postText: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
