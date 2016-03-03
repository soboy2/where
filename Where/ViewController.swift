//
//  ViewController.swift
//  LaVista
//
//  Created by Sofolahan Soboyejo on 2/18/16.
//  Copyright © 2016 Sho. All rights reserved.
//

import UIKit
import CoreLocation
import AddressBookUI


class ViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var localityTxtField: UILabel!
    @IBOutlet weak var postalCodeTxtField: UILabel!
    @IBOutlet weak var aAreaTxtField: UILabel!
    @IBOutlet weak var countryTxtField: UILabel!
    @IBOutlet weak var streetTxtField: UILabel!
    
    let manager = CLLocationManager()

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        localityTxtField.hidden = false
        postalCodeTxtField.hidden = false
        aAreaTxtField.hidden = false
        countryTxtField.hidden = false
        streetTxtField.hidden = false
    }
    
    @IBAction func findMe(sender: UIButton) {
        //make class a delegate
        manager.delegate = self
        //specify location accuracy
        manager.desiredAccuracy = kCLLocationAccuracyBest
        
        
        /*if CLLocationManager.authorizationStatus() == .NotDetermined {
            manager.requestWhenInUseAuthorization()
            manager.startMonitoringSignificantLocationChanges()
        }*/
        
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        
        print(manager.location)

    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        //check if app is authorized to access location
        if status == .AuthorizedAlways || status == .AuthorizedWhenInUse {
            manager.startUpdatingLocation()
            print(manager.location)
            
        } else {
            print("Sorry, no location")
            
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        CLGeocoder().reverseGeocodeLocation(manager.location!, completionHandler: {(placemarks, error)->Void in
            
            if(error != nil) {
                print("Reverse geocoder failed with error" + error!.localizedDescription)
                return
            }
            
            if placemarks!.count > 0 {
                let pm = placemarks![0] 
                self.displayLocationInfo(pm)
            } else {
                print("Problem with the data received from geocoder")
            }
        
        })
    }
    
    func displayLocationInfo(placemark: CLPlacemark?) {
        if let containsPlacemark = placemark {
            //stop updating location to save battery life
            manager.stopUpdatingLocation()
            let locality = (containsPlacemark.locality != nil) ? containsPlacemark.locality : ""
            let postalCode = (containsPlacemark.postalCode != nil) ? containsPlacemark.postalCode : ""
            let administrativeArea = (containsPlacemark.administrativeArea != nil) ? containsPlacemark.administrativeArea : ""
            let country = (containsPlacemark.country != nil) ? containsPlacemark.country : ""
            let street = (containsPlacemark.addressDictionary != nil) ? ABCreateStringWithAddressDictionary(containsPlacemark.addressDictionary!, false): ""
            
            //let street = (containsPlacemark.thoroughfare != nil) ? containsPlacemark.thoroughfare: ""

        
            
            localityTxtField.text = locality
            postalCodeTxtField.text = postalCode
            aAreaTxtField.text = administrativeArea
            countryTxtField.text = country
            streetTxtField.text = street
            
        }
    }

    func reverseGeocoding(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let location = CLLocation(latitude: latitude, longitude: longitude)
        CLGeocoder().reverseGeocodeLocation(location, completionHandler: {(placemarks, error) -> Void in
            if error != nil {
                print(error)
                return
            }
            else if placemarks?.count > 0 {
                let pm = placemarks![0]
                let address = ABCreateStringWithAddressDictionary(pm.addressDictionary!, false)
                print("\n\(address)")
                if pm.areasOfInterest?.count > 0 {
                    let areaOfInterest = pm.areasOfInterest?[0]
                    print(areaOfInterest!)
                } else {
                    print("No area of interest found.")
                }
            }
        })
    }
    
    func forwardGeocoding(address: String) {
        CLGeocoder().geocodeAddressString(address, completionHandler: { (placemarks, error) in
            if error != nil {
                print(error)
                return
            }
            if placemarks?.count > 0 {
                let placemark = placemarks?[0]
                let location = placemark?.location
                let coordinate = location?.coordinate
                print("\nlat: \(coordinate!.latitude), long: \(coordinate!.longitude)")
                if placemark?.areasOfInterest?.count > 0 {
                    let areaOfInterest = placemark!.areasOfInterest![0]
                    print(areaOfInterest)
                } else {
                    print("No area of interest found.")
                }
            }
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }



}

