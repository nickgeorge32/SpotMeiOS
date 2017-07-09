//
//  EventDetailsViewController.swift
//  SpotMe
//
//  Created by Nicholas George on 7/9/17.
//  Copyright © 2017 Nicholas George. All rights reserved.
//

import UIKit
import Parse

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
        let eventQuery = PFQuery(className: "Events")
        eventQuery.whereKey("Title", equalTo: eventTitleString)
        eventQuery.findObjectsInBackground { (objects, error) in
            if let events = objects {
                for object in events {
                    if let event = object as? PFObject {
                        var lastActive = object["eventDate"]
                        if lastActive != nil {
                            let dateFormatter = DateFormatter()
                            dateFormatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss.SSS'Z'"
                            let date = dateFormatter.string(from: (lastActive as! NSDate) as Date)
                            print(date)
                            self.eventDate.text = date
                        }
                        
                        //self.eventDate.text = object["eventDate"] as! NSDate?
                        self.eventFee.text = object["eventFee"] as! String?
                        self.eventLocation.text = event["eventLocation"] as! String?
                    }
                }
            }
        }
        
    }
}
