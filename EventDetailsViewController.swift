//
//  EventDetailsViewController.swift
//  SpotMe
//
//  Created by Nicholas George on 7/9/17.
//  Copyright © 2017 Nicholas George. All rights reserved.
//

import UIKit

class EventDetailsViewController: UIViewController {
    @IBOutlet var eventImage: UIImageView!
    @IBOutlet var eventTitle: UILabel!
    @IBOutlet var eventDate: UILabel!
    @IBOutlet var eventFee: UILabel!
    @IBOutlet var eventLocation: UILabel!
    
    var eventTitleString: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        eventTitle.text = eventTitleString
    }
    
    override func viewDidAppear(_ animated: Bool) {
        getEventDetails()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getEventDetails() {
        
    }
}
