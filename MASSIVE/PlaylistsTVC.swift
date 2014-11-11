
//
//  playlistsTVC.swift
//  MASSIVE
//
//  Created by Faiyam Rahman on 11/7/14.
//  Copyright (c) 2014 CornellTech. All rights reserved.
//

import UIKit

class PlaylistsTVC: UITableViewController {

//    @IBOutlet // makes the property visible in Interface Builder
//    var tableView: UITableView!
    
    var items: NSDictionary?
//    var items: [String] = ["Testing", "out", "code", "Testing", "out", "code",
//                           "Testing", "out", "code", "Testing", "out", "code",
//                           "Testing", "out", "code"]

    var location: String?
    
    override func viewDidLoad() {
        // Do any additional setup after loading the view.
        // register the tableView class
//        self.tableView = UITableView(frame: CGRectMake(0, 0, 100, 100), style: UITableViewStyle.Plain)
        
        // tells the tableView what class of UITableViewCell to create if theres none on 
        // the reuse queue, and what identifier to give it.
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.tableView.scrollEnabled = true // make that shit scrollable
        
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let playlistArray = self.items!.objectForKey(self.location!) as NSArray
        return playlistArray.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        println("tableView: \(tableView)")
        
        var cell:UITableViewCell? = tableView.dequeueReusableCellWithIdentifier("cell") as? UITableViewCell
        
        cell!.textLabel!.text = "hello"
        let playlistArray = self.items!.objectForKey(self.location!) as NSArray
        let playlist = playlistArray[indexPath.row] as NSDictionary
        
        cell!.textLabel!.text = playlist.objectForKey("title") as NSString
        
        return cell!
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let playlistArray = self.items!.objectForKey(self.location!) as NSArray
        let playlistInfo = playlistArray[indexPath.row] as NSDictionary
        
        NSNotificationCenter.defaultCenter().postNotificationName("playPlaylist", object: nil, userInfo: playlistInfo)
        
        println("You selected #\(indexPath.row)")
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
