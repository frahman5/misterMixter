
//
//  playlistsTVC.swift
//  MASSIVE
//
//  Created by Faiyam Rahman on 11/7/14.
//  Copyright (c) 2014 CornellTech. All rights reserved.
//

import UIKit

class PlaylistsTVC: UITableViewController {

    // Dictionary with <String, NSArray> structure. Keys are locations,
    // values are Arrays with Dictionary entries e.g [dictionary, dictionary, ..., dictionary]
    // Each inner dictionary is a soundcloud playlist api call json response, obviously
    // containing metadata on a soundcloud playlist
    var items: NSDictionary!

    // The location that the user has currently selected.
    var location: String!
    
    // each playlist is a dictionary containing metadata on a soundcloud playlist
    var playlistArray: NSArray!
    
    // the color for our view
    let backgroundColor = UIColor(red: 0.0/255.05, green: 64.0/255.0, blue: 128.0/255.0, alpha: 1.0)
    override func viewDidLoad() {
        
        // tells the tableView what class of UITableViewCell to create if theres none on 
        // the reuse queue, and what identifier to give it.
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        // give us a background color
        self.view.backgroundColor = self.backgroundColor
        
        super.viewDidLoad()
    }
    
    func setPlaylistArray() {
        /* set the instance variable playlistArray once and for all */
        
        // Make sure we have set self.items and self.location
        assert(self.items != nil)
        assert(self.location != nil)
        
        // set the playlistArray
        self.playlistArray = self.items.objectForKey(self.location) as NSArray
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.playlistArray.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        // create a cell
        var cell:UITableViewCell? = tableView.dequeueReusableCellWithIdentifier("cell") as? UITableViewCell
        if (cell == nil) {
            cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "cell")
        }
        
        // retrieve the playlist that corresponds to this index path
        let playlist = self.playlistArray[indexPath.row] as NSDictionary
        
        // label the cell and give the text a color
        cell!.textLabel.text = playlist.objectForKey("title") as NSString
        cell!.textLabel.textColor = UIColor(white: 1, alpha: 1)
        
//         extract the waveform url for the first track and place it on the cell
//        let tracks = playlist.objectForKey("tracks") as NSArray
//        var cell_image_url_string: NSString
//        var cell_image: UIImage
//        for tracks_dict_object in tracks {
//            let tracks_dict = tracks_dict_object as NSDictionary
//            cell_image_url_string = tracks_dict.objectForKey("artwork_url")
//            if (cell_image_url_string != nil) {
//                break
//            }
//        }
//        if (cell_image_url_string == nil) {
//            cell_image = UIImage(named: "twitter_50.png")
//        } else {
//            let image_url = NSURL(string: cell_image_url_string)
//            let image_data = NSData(contentsOfURL: image_url!)
//            cell_image = UIImage(data: image_data!)
//        }
//        let tracks_dict =
//        let cell_image_url_string = tracks_dict.objectForKey("waveform_url") as NSString
//        let image_url = NSURL(string: cell_image_url_string)
//        let image_data = NSData(contentsOfURL: image_url!)
//        cell_image = UIImage(data: image_data!)
//
//        cell!.imageView.image = cell_image
//        cell!.imageView.bounds = CGRectMake(0, 0, 0.5, 20) // x, y, width, height
//        cell!.imageView.clipsToBounds = true
        
        // give the cell a color
        cell!.backgroundColor = self.backgroundColor
        
        
        
        return cell!
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        // extract the dictionary with metadata on THIS playlist
        let playlistInfo = self.playlistArray[indexPath.row] as NSDictionary
        
        // tell the first view controller to play this playlist, feeding it the necessary info
        NSNotificationCenter.defaultCenter().postNotificationName("playPlaylist", object: nil, userInfo: playlistInfo)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
