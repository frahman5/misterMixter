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
    
    // Scroll-y view for user locations and the associated data structures
    @IBOutlet var userLocations: UIPickerView!
    var userLocationsArray: Array<String>!
    var foundLocation: Bool?
    
    // location manager to find user location
    let locationManager = CLLocationManager()
    
    // TableViewController to list playlists
    let playlistTVC = PlaylistTableViewController()
    
    // SoundCloudHandler
    let scHandler = SoundCloudHandler()
    
    @IBAction func testAction(sender: AnyObject) {

        self.scHandler.playPlaylist(0)
        println("change page1")
    }
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    

        
        // Ask for location permission and once received, determine location
        
        
//        while (self.foundLocation == nil) {
//            locationManager.requestWhenInUseAuthorization()
//            self.findMyLocation()
//        }

        
        // Place tableView of playlists up
        let playlistViewBounds = CGRectMake(0, 268, 320, 251)
        self.playlistTVC.view.frame = playlistViewBounds
        self.view.addSubview(self.playlistTVC.view)
        
        // Tell me you ran
        println("Ran viewDidLoad")
        
        
        
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
        
        // Indicate that we've found location
        self.foundLocation = true
        
        // Fetch playlists
        self.scHandler.fetchPlaylistsForLocation("Location")
        
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
    
    
    override func prepareForSegue(segue: UIStoryboardSegue?, sender: AnyObject?) {
        println("prepare for segue")
        
        println("sender: %@", sender)
  
        if (segue?.identifier == "goToPlayPage") {
            let viewController:PlayPageViewController = segue!.destinationViewController as PlayPageViewController
            assert(sender != nil)
            assert(segue != nil)
            //        assert(viewController as Bool)
            self.scHandler.setViewController(viewController)
        }

        
    }
}


