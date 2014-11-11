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
    
    // SoundCloudHandler
    let scHandler = SoundCloudHandler()
    
    // TableViewController to list playlists
    let playlistTVC = PlaylistsTVC(style: UITableViewStyle.Plain)
    
    // listen for notifcations
    let listener = NSNotificationCenter.defaultCenter()
    
    // the controller that we'll push to when we play stuff
    let playController = PlayPageViewController()
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    override func viewDidLoad() {
        
        // Ask for location permission and once received, determine location
//        while (self.foundLocation == nil) {
//            locationManager.requestWhenInUseAuthorization()
//            self.findMyLocation()
//        }
        
        // Populate UIPickerView (Make this less fake later)
        self.userLocationsArray = ["Cornell Tech", "Chelsea", "New York"]
        self.userLocations.dataSource = self
        self.userLocations.delegate = self
        
        // Configure a PlayPageViewController for later
        self.playController.scHandler = self.scHandler
        self.scHandler.setViewController(self.playController)
        
        // When we get the access token, find playlists and populate the table
        self.listener.addObserver(self, selector: "searchPlaylists:", name: "accessToken", object: nil)
        
        // When we've retrieved playlist metadata, play the playlist and change screens
        self.listener.addObserver(self, selector: "playThisPlaylist:", name: "playPlaylist", object: nil)
        
        super.viewDidLoad()
        
    }
    
    func playThisPlaylist(notification: NSNotification) {
        /* Once the scHandler has found the playlist information, 
           present the play page view controller and play the playlist */
        
        // Tell the play controller where to get its playlist info
        let playlistInfo = notification.userInfo! as NSDictionary
        self.playController.playlistInfo = playlistInfo
        
        // stop listening for that notification
        self.listener.removeObserver(self, name: "playPlaylist", object: nil)
        
        // Present the view controller
        self.presentViewController(playController, animated: true, completion: nil)
    }
    
    func searchPlaylists(notification: NSNotificationCenter) {
        /* Once the scHandler has retrieved our soundcloud access token, 
           tell it to get the playlists for our user's location */
        
        // Get the playlists
        self.scHandler.getPlaylists(self.userLocationsArray)
        
        // stop listening for that notification
        self.listener.removeObserver(self, name: "accessToken", object: nil)
        
        // start listening for a notification on having found the playlists
        self.listener.addObserver(self, selector: "populatePlaylists:", name: "foundPlaylists", object: nil)
        
    }
    
    func populatePlaylists(notification: NSNotification) {
        /* Once the scHandler has found the playlists, populate our table view
           with the titles */
        
        // retrieve the playlists
        let playlists = notification.userInfo! as NSDictionary
        let location = "Chelsea"
        
        // stop listening for that notication
        self.listener.removeObserver(self, name: "foundPlaylists", object: nil)
        
        // Place tableView of playlists up
        let playlistViewBounds = CGRectMake(0, 268, 320, 251)
        self.playlistTVC.view.frame = playlistViewBounds
        self.playlistTVC.items = playlists
        self.playlistTVC.location = location
        self.playlistTVC.setPlaylistArray()
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
  
        if segue?.identifier == "goToPlayerVC" {
            let viewController:playerVC = segue!.destinationViewController as playerVC
            viewController.scHandler = self.scHandler
            self.scHandler.setViewController(viewController)
        } else {
            assert (segue?.identifier == "goToPlayPage")
            let viewController:PlayPageViewController = segue!.destinationViewController as PlayPageViewController
            viewController.scHandler = self.scHandler
            self.scHandler.setViewController(viewController)
        }

        
    }
}


