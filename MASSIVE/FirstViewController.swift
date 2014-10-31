//
//  FirstViewController.swift
//  MASSIVE
//
//  Created by Faiyam Rahman on 10/30/14.
//  Copyright (c) 2014 CornellTech. All rights reserved.
//

import UIKit
import CoreLocation


class FirstViewController: UIViewController, CLLocationManagerDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    // Scroll-y view for user locations and the associated data structure
    @IBOutlet var userLocations: UIPickerView!
    var userLocationsArray: Array<String>!
    
    // location manager to find user location
    let locationManager = CLLocationManager()
    
    // TableViewController
    let playlistTVC = PlaylistTableViewController()
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Ask for location permission and once received, determine location
        locationManager.requestWhenInUseAuthorization()
        println("Ran viewDidLoad")
        var timer = NSTimer.scheduledTimerWithTimeInterval(0.4, target: self,
            selector: Selector("findMyLocation"), userInfo: nil, repeats: true)
        
        // change to using CGRect
        let playlistViewBounds = CGRectMake(0, 268, 320, 251)
        self.playlistTVC.view.frame = playlistViewBounds
        
        self.view.addSubview(self.playlistTVC.view)
        
        
        
    }
    
    func findMyLocation() {
        
        // If the user hasn't given us permission yet, don't run location services
        if (CLLocationManager.authorizationStatus() != CLAuthorizationStatus.AuthorizedWhenInUse) {
            println("user hasn't given us permission")
            return
        }
        
        // set location manager parameters and look for location
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        
        // take the lat/long data and turn it into city/state/POI
        let geoCoder = CLGeocoder()
        geoCoder.reverseGeocodeLocation(locationManager.location,
            completionHandler: { (placemarks, error) -> Void in
                
                println("Ran reverse Geo Code")
                // handle error if need be
                if (error != nil) {
                    println("Geocoder failed with error code" + error.localizedDescription)
                    return
                }
                
                // report the placemark. IN FUTURE SHOULD HANDLE MULTIPLE ENTRIES
                if (placemarks.count > 0) {
                    let pm = placemarks[0] as CLPlacemark
                    
                    // initalize the data
                    self.userLocationsArray = [pm.name, pm.subLocality, pm.subAdministrativeArea]
                    
                    // connect the data
                    self.userLocations.dataSource = self
                    self.userLocations.delegate = self
                } else {
                    println("Problem with the data received from geocoder")
                }
        })
    }
    
    // The number of columns of data
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // The number of rows of data
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return userLocationsArray.count
    }
    
    // The data for the row and component passed
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return userLocationsArray[row]
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet var playlistRequested: UIButton!
    
//    override func prepareForSegue(segue: UIStoryboardSegue?, sender: AnyObject?) {
//        println("prepare for segue")
//        
//        let viewController:SongViewController = segue!.destinationViewController as SongViewController
//        if (segue!.identifier == "playlist1") {
//            viewController.whichButtonPressed = 1
//        } else if (segue!.identifier == "playlist2") {
//            viewController.whichButtonPressed = 2
//        } else if (segue!.identifier == "playlist3") {
//            viewController.whichButtonPressed = 3
//        }
//        
//        // Get the new view controller using segue.destinationViewController.
//        // Pass the selected object to the new view controller.
//    }
}


