
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
    
    override func viewDidLoad() {
        
        // tells the tableView what class of UITableViewCell to create if theres none on 
        // the reuse queue, and what identifier to give it.
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
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
        
        // retrieve the playlist that corresponds to this index path
        let playlist = self.playlistArray[indexPath.row] as NSDictionary
        
        // label the cell
        cell!.textLabel!.text = playlist.objectForKey("title") as NSString
        
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
