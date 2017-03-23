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

class NearMeViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    var locationManager = CLLocationManager()
    var userLocation: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    var nearbyUsers = [String]()
    var nearbyUserLocations = [CLLocationCoordinate2D]()
    var nearUser: String? = ""

    @IBOutlet var mapView: MKMapView!
    @IBOutlet var userLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
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
            displayAlert(title: "Location Error", message: "Unable to get location at this time, using last saved location")
            userLocation.latitude = (PFUser.current()?["userLocation"] as AnyObject).latitude
            userLocation.longitude = (PFUser.current()?["userLocation"] as AnyObject).longitude
        }
        
        let query = PFUser.query()
        query?.whereKey("userLocation", nearGeoPoint: PFGeoPoint(latitude: userLocation.latitude, longitude: userLocation.longitude))
        query?.findObjectsInBackground(block: { (objects, error) in
            if let users = objects {
                self.nearbyUsers.removeAll()
                self.nearbyUserLocations.removeAll()
                self.mapView.removeAnnotations(self.mapView.annotations)
                
                for object in users {
                    if let user = object as? PFUser {
                        self.nearbyUsers.append(user.username!)
                        self.nearbyUserLocations.append(CLLocationCoordinate2D(latitude: (object["userLocation"] as AnyObject).latitude, longitude: (object["userLocation"] as AnyObject).longitude))
                        let annotation = MKPointAnnotation()
                        annotation.coordinate = CLLocationCoordinate2D(latitude: (object["userLocation"] as AnyObject).latitude, longitude: (object["userLocation"] as AnyObject).longitude)
                        annotation.title = user.username
                        self.mapView.addAnnotation(annotation)
                    }
                }
            }
        })
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = manager.location?.coordinate {
            userLocation = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
            let region = MKCoordinateRegion(center: userLocation, span: MKCoordinateSpan(latitudeDelta: 80, longitudeDelta: 80))

            self.mapView.setRegion(region, animated: true)
            
        }
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
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        var view = mapView.dequeueReusableAnnotationView(withIdentifier: "AnnotationView Id")
        if view == nil{
            view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "AnnotationView Id")
            view!.canShowCallout = true
        } else {
            view!.annotation = annotation
        }
        
        view?.leftCalloutAccessoryView = nil
        view?.rightCalloutAccessoryView = UIButton(type: UIButtonType.infoLight)
        
        return view
    }
        
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if let annotation = view.annotation {
            nearUser = annotation.title!

            let myVC = storyboard?.instantiateViewController(withIdentifier: "NearbyUserInfo") as! NearbyUserInfoViewController
            myVC.passedUsername = nearUser!
            mapView.deselectAnnotation(view.annotation, animated: true)
            navigationController?.pushViewController(myVC, animated: true)
        }
    }
}
