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
    let userLocations = UIPickerView()
    var userLocationsArray: Array<String>!
    
    // location manager to find user location
    let locationManager = CLLocationManager()
    
    // This object handles all direct interaction with the soundcloud api
    let scHandler = SoundCloudHandler()
    
    // TableViewController to list playlists
    let playlistTVC = PlaylistsTVC(style: UITableViewStyle.Plain)
    
    // listen for notifcations
    let listener = NSNotificationCenter.defaultCenter()
    
    // Things the PlayPageViewController will need
    var playlistInfo: NSDictionary!
    let playController = PlayPageViewController()
    
    
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    override func viewDidLoad() {
        
        
        // Put a background image in top of the screen
        let frame = self.view.frame
        var backgroundImage = UIImage(named: "mixter_60.png")
        var backgroundImageView = UIImageView(image: backgroundImage)
        let imageHeight = (1/2) * CGRectGetHeight(frame)
        backgroundImageView.frame = CGRectMake(0, 20, CGRectGetWidth(frame), imageHeight)
        self.view.addSubview(backgroundImageView)

        // put a pickerview on the background image
        self.userLocations.frame = CGRectMake(0, 0, CGRectGetWidth(frame), imageHeight)
        self.view.addSubview(self.userLocations)
        
        // Configure a PlayPageViewController for later
        self.playController.scHandler = self.scHandler
        self.scHandler.ppvC = self.playController as PlayPageViewController
        
        // When we get the access token, wait for access token then find playlists and populate the table
        self.listener.addObserver(self, selector: "waitForLocationBeforeSearchingPlaylists:", name: "accessToken", object: nil)
        
        // When we've retrieved playlist metadata, play the playlist and change screens
        self.listener.addObserver(self, selector: "playThisPlaylist:", name: "playPlaylist", object: nil)
        
        super.viewDidLoad()
        
    }
    
    func findMyLocation() {
        
        //        // If the user hasn't given us permission yet, don't run location services
        //        if (CLLocationManager.authorizationStatus() != CLAuthorizationStatus.AuthorizedWhenInUse) {
        //            println("user hasn't given us permission")
        //            return
        //        }
        
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
                    println("successfully reverse geocded location")
                    self.userLocationsArray = [pm.name, pm.subLocality, pm.subAdministrativeArea]
                    
                    // connect the data
                    self.userLocations.dataSource = self
                    self.userLocations.delegate = self
                    
                    // post a notification that we've found location
                    println("foundLocation")
                    self.listener.postNotificationName("foundLocation", object: nil)
                    
                    
                    
                } else {
                    println("Problem with the data received from geocoder")
                }
        })
        
        
    }

    func waitForLocationBeforeSearchingPlaylists(notification: NSNotification) {
        /* Once the scHandler has retrieved our soundcloud access token, 
           start looking for the notifcation that we've found user location. 
           Once we find user location, tell scHandler to get playlists */
        
        // stop listening for the access token notification
        self.listener.removeObserver(self, name: "accessToken", object: nil)
        
        // start listening for the locationsFound notification
        self.listener.addObserver(self, selector: "searchPlaylists:", name: "foundLocation", object: nil)
        
        // Ask for location permission. Then determine location
        locationManager.requestWhenInUseAuthorization()
        self.findMyLocation()
    }
    
    func playThisPlaylist(notification: NSNotification) {
        /* Once the scHandler has found the playlist information, 
           present the play page view controller and play the playlist */
        
        // Tell the play controller where to get its playlist info
//        let playlistInfo = notification.userInfo! as NSDictionary
//        self.playController.playlistInfo = playlistInfo
        
        // Extract information controller will need to play music
        self.playlistInfo = notification.userInfo! as NSDictionary
        
        // stop listening for that notification
        self.listener.removeObserver(self, name: "playPlaylist", object: nil)
        
        self.performSegueWithIdentifier("goToPlayPage", sender: self)
//        [self performSegueWithIdentifier:@"Associate" sender:sender]
        // Present the view controller
//        self.presentViewController(playController, animated: true, completion: nil)
    }
    
    func searchPlaylists(notification: NSNotification) {
        /* Once the scHandler has retrieved our soundcloud access token, 
           tell it to get the playlists for our user's location */
        
        // Get the playlists
        self.scHandler.getPlaylists(self.userLocationsArray)
        println("We search for playlists")

        // start listening for a notification on having found the playlists
        self.listener.addObserver(self, selector: "populatePlaylists:", name: "foundPlaylists", object: nil)
        
    }
    
    func populatePlaylists(notification: NSNotification) {
        /* Once the scHandler has found the playlists, populate our table view
           with the titles */
        
        // retrieve the playlists
        let playlists = notification.userInfo! as NSDictionary
        let location = self.userLocationsArray[0]
        
        // stop listening for that notication
        self.listener.removeObserver(self, name: "foundPlaylists", object: nil)
        
        // Place tableView of playlists up
        let frame = self.view.frame
        let playlistHeight = (3/5) * CGRectGetHeight(frame)
        let playlistViewBounds = CGRectMake(0, 268, 320, playlistHeight - 20)
        self.playlistTVC.view.frame = playlistViewBounds
        self.playlistTVC.items = playlists
        self.playlistTVC.location = location
        self.playlistTVC.setPlaylistArray()
        self.view.addSubview(self.playlistTVC.view)
        
    }
    
    // The number of columns of data
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // The number of rows of data
    func pickerView(pickerView: UIPickerView,
        numberOfRowsInComponent component: Int) -> Int {
        return userLocationsArray.count
    }
    
    // The data for the row and component passed
    func pickerView(pickerView: UIPickerView, titleForRow row: Int,
        forComponent component: Int) -> String! {
        return userLocationsArray[row]
    }
    
    func pickerView(pickerView: UIPickerView,
        attributedTitleForRow row: Int,
        forComponent component: Int) -> NSAttributedString? {
        let attrs = [NSForegroundColorAttributeName: UIColor(white: 1, alpha: 1)]
        let startString = userLocationsArray[row]
        var attributedString = NSAttributedString(string: startString, attributes: attrs)
            
        return attributedString
    }
    
    // What to do when a row on the picker view gets selected
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int,
        inComponent component: Int) {
            
        // reset the location on the tableViewController
        let location = userLocationsArray[row]
        self.playlistTVC.location = location
        self.playlistTVC.setPlaylistArray()
        
        // tell it to reload its rows
        self.playlistTVC.tableView.reloadData()
            
        // change the background image

            
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "goToPlayPage") {
            let playPageVC = segue.destinationViewController as PlayPageViewController
            
            // give it what it needs to play music
            playPageVC.scHandler = self.scHandler
            playPageVC.playlistInfo = self.playlistInfo
//            playPageVC.songTitle.text = "it works!!!"
        }
    }
    
}


