//
//  PlayPageViewController.swift
//  MASSIVE
//
//  Created by Faiyam Rahman on 10/31/14.
//  Copyright (c) 2014 CornellTech. All rights reserved.
//

import UIKit
import AVKit
import Social


class PlayPageViewController: UIViewController {
    
    var player: AVPlayer!
    var scHandler: SoundCloudHandler!
    var playlistInfo: NSDictionary?
    let listener = NSNotificationCenter.defaultCenter()
    
    @IBOutlet var songTitle: UILabel!
    
    @IBAction func nextSong(sender: AnyObject) {
        self.scHandler.nextSong()
    }
    
    @IBAction func previousSong(sender: AnyObject) {
        self.scHandler.previousSong()
    }
    
    
    
    // play and pause button images
    let pauseImage: UIImage! = UIImage(named: "pause.png")
    let playImage: UIImage! = UIImage(named: "play.png")
    
    @IBOutlet var playPauseButton: UIButton!
    
    
    @IBAction func pauseOrPlay(sender: AnyObject) {
        
        // What to do if its currently playing
        if (self.playPauseButton.currentImage! == self.pauseImage) {
            self.scHandler!.pause()
            self.playPauseButton.setImage(self.playImage, forState: UIControlState.Normal)
        } else {
            // what to do its currently paused
            assert(self.playPauseButton.currentImage! == self.playImage)
            self.scHandler!.play()
            self.playPauseButton.setImage(self.pauseImage, forState: UIControlState.Normal)
        }
    }
    
    override func viewDidLoad() {
        // set up a listener so we know when to change song Title
        self.listener.addObserver(self,
            selector: "setSongInfo:", name: "changeTrackInfo", object: nil)
        
        // play that playlist
        let title = self.playlistInfo!.objectForKey("title") as NSString!
        var uri = self.playlistInfo!.objectForKey("uri") as NSString!
        self.scHandler.playPlaylist(uri)
        
        // set up gesture recognizers
            // Right swipe plays the next song
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: "nextSong:")
        rightSwipe.direction = UISwipeGestureRecognizerDirection.Right
        view.addGestureRecognizer(rightSwipe)
        
            // Left swipe plays the previous song
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: "previousSong:")
        leftSwipe.direction = UISwipeGestureRecognizerDirection.Left
        view.addGestureRecognizer(leftSwipe)
        
        super.viewDidLoad()
        
        // Initiates screen fadeing.
        self.playPauseButton.alpha = 0
        
        // Do any additional setup after loading the view.
    }
    
    
    
    
    
// 'Action' share button
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        let firstActivityItem = "Testing...mister Mixter :)"
        
        let activityViewController : UIActivityViewController = UIActivityViewController(activityItems: [firstActivityItem], applicationActivities: nil)
        
        self.presentViewController(activityViewController, animated: true, completion: nil)
        
        
        UIView.animateWithDuration(3.0, animations: {
            self.playPauseButton.alpha = 1.0
        })
        
    }
    

//  facebook share function
    @IBAction func facebookShare(sender: AnyObject) {
        
        if SLComposeViewController.isAvailableForServiceType(SLServiceTypeFacebook){
        
            var facebookSheet:SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
            
            facebookSheet.setInitialText("Check out this track on misterMixter...")
            
            self.presentViewController(facebookSheet, animated: true, completion: nil)
            
        } else {
            
            var alert = UIAlertController(title: "Accounts", message: "Please login to a Facebook account to share.", preferredStyle: UIAlertControllerStyle.Alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            
            self.presentViewController(alert, animated: true, completion: nil)
            
        }
    }
    
        

// twitter share funtion
    @IBAction func twitterShare(sender: AnyObject) {
        
        if SLComposeViewController.isAvailableForServiceType(SLServiceTypeTwitter){
                
            var tweetSheet:SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
                
            tweetSheet.setInitialText("Check out this track on misterMixter...")
            
            self.presentViewController(tweetSheet, animated: true, completion: nil)
                
            } else {
            
            var alert = UIAlertController(title: "Accounts", message: "Please login to a Twitter account to share.", preferredStyle: UIAlertControllerStyle.Alert)
                
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                
            self.presentViewController(alert, animated: true, completion: nil)
                
        }
    }
    
    

    func setSongInfo(notification: NSNotification) {
        /*
            Changes the UI to reflect info on the current song
        */
        let trackDict = notification.userInfo! as NSDictionary
        self.songTitle.text = trackDict["title"] as NSString
        
        // change the playPauseButton to indicate pausing
        self.playPauseButton.setImage(self.pauseImage, forState: UIControlState.Normal)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
