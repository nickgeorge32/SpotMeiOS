//
//  NearMeViewController.swift
//  SpotMe
//
//  Created by Nicholas George on 3/19/17.
//  Copyright © 2017 Nicholas George. All rights reserved.
//

import UIKit
import MapKit
import Firebase
import GeoFire

class NearMeViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    var locationManager = CLLocationManager()
    var userLocation: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    var nearbyUsers = [String]()
    var nearbyUserLocations = [CLLocationCoordinate2D]()
    var nearUser: String? = ""
    
    @IBOutlet var mapView: MKMapView!
    @IBOutlet var userLabel: UILabel!
    
    var dbRef:DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dbRef = Database.database().reference()
        
        navigationController?.isNavigationBarHidden = true
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        pendingFriendRequestCheck()
        mapView.removeAnnotations(mapView.annotations)
        
        let geoFire = GeoFire(firebaseRef: dbRef.child("userLocations"))
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) { 
            if self.userLocation.latitude != 0 && self.userLocation.longitude != 0 {
                geoFire?.setLocation(CLLocation(latitude: self.userLocation.latitude, longitude: self.userLocation.longitude), forKey: Auth.auth().currentUser?.uid)
            } else {
                self.displayAlert(title: "Location Error", message: "Unable to get location at this time, please try again")
            }
            let center = CLLocation(latitude: self.userLocation.latitude, longitude: self.userLocation.longitude)
            var circleQuery = geoFire?.query(at: center, withRadius: 1.7)
            var email = ""
            var queryHandle = circleQuery?.observe(.keyEntered, with: { (key, location) in
                if key != Auth.auth().currentUser?.uid {
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = CLLocationCoordinate2D(latitude: (location?.coordinate.latitude)!, longitude: (location?.coordinate.longitude)!)
                    let name = key
                    self.dbRef.child("users").child(name!).observeSingleEvent(of: .value, with: { (snapshot) in
                        let value = snapshot.value as? NSDictionary
                        email = (value?["email"] as? String)!
                        annotation.title = email
                    })
                    self.mapView.addAnnotation(annotation)
                }
            })
        }
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = manager.location?.coordinate {
            userLocation = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
            let region = MKCoordinateRegion(center: userLocation, span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2))
            
            self.mapView.setRegion(region, animated: true)
            
        }
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
    
    func pendingFriendRequestCheck() {
        var badgeValue = 0
    }
}
