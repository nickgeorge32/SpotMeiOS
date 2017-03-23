//
//  NearMeViewController.swift
//  SpotMe
//
//  Created by Nicholas George on 3/19/17.
//  Copyright © 2017 Nicholas George. All rights reserved.
//

import UIKit
import MapKit
import Parse

class NearMeViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, UITableViewDelegate, UITableViewDataSource {
    var locationManager = CLLocationManager()
    var userLocation: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    var nearbyUsers = [String]()
    var nearbyUserLocations = [CLLocationCoordinate2D]()

    @IBOutlet var map: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()

    }

    override func viewDidAppear(_ animated: Bool) {
        if userLocation.latitude != 0 && userLocation.longitude != 0 {
            PFUser.current()?["userLocation"] = PFGeoPoint(latitude: userLocation.latitude, longitude: userLocation.longitude)
            
            PFUser.current()?.saveInBackground(block: { (success, error) in
                if error != nil {
                    var errorMessage = "Unable to save location"
                    if let parseError = (error as! NSError).userInfo["error"] as? String {
                        errorMessage = parseError
                        self.displayAlert(title: "Error", message: errorMessage)
                    }
                }
            })
        } else {
            displayAlert(title: "Location Error", message: "Unable to get your location at this time, please try again.")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = manager.location?.coordinate {
            userLocation = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
            let region = MKCoordinateRegion(center: userLocation, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            self.map.setRegion(region, animated: true)
            
            let query = PFUser.query()
            query?.whereKey("userLocation", nearGeoPoint: PFGeoPoint(latitude: location.latitude, longitude: location.longitude))
            query?.findObjectsInBackground(block: { (objects, error) in
                if let users = objects {
                    self.nearbyUsers.removeAll()
                    self.nearbyUserLocations.removeAll()
                    
                    for object in users {
                        if let user = object as? PFUser {
                            self.nearbyUsers.append(user.username!)
                            self.nearbyUserLocations.append(CLLocationCoordinate2D(latitude: (object["userLocation"] as AnyObject).latitude, longitude: (object["userLocation"] as AnyObject).longitude))
                        }
                    }
                }
            })
            print("nearby is \(nearbyUsers), \(nearbyUserLocations)")
        }
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        cell.textLabel?.text = "Test"
        
        return cell
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func displayAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }

}
