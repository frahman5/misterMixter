//
//  PlayPageViewController.swift
//  MASSIVE
//
//  Created by Faiyam Rahman on 10/31/14.
//  Copyright (c) 2014 CornellTech. All rights reserved.
//

import UIKit

class PlayPageViewController: UIViewController {
    
    var scHandler: SoundCloudHandler!
    @IBOutlet var songTitle: UILabel!
    
    @IBAction func nextSong(sender: AnyObject) {
        self.scHandler.nextSong()
    }
    
    @IBAction func previousSong(sender: AnyObject) {
        self.scHandler.previousSong()
    }
    
    let pauseImage: UIImage = UIImage(contentsOfFile: "pause.png")
//    let pauseImage: UIImage = UIImage(named: "pause.png")
    let playImage: UIImage = UIImage(named: "play.png")
    
    @IBOutlet var playPauseButton: UIButton!
    convenience init(scHandler: SoundCloudHandler) {
        println("ran custom init")
        self.init()
        self.scHandler = scHandler
        println("@self.schandler: \(self.scHandler)")

    }
    
    @IBAction func pause(sender: AnyObject) {
        // send soundCloundHandler the message to pause
        self.playPauseButton.setImage(self.playImage, forState: UIControlState.Normal)
        self.scHandler!.pause()
    }
    
    
    func setSongTitle(songTitle: NSString) {
        println("song title: %@", songTitle)
        self.songTitle.text = songTitle
//        self.songTitle.text = songTitle
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.playPauseButton.setImage(self.pauseImage, forState:UIControlState.Normal)
        println("We opened the right view controller")
        
        // set up gesture recognizers
            // Right swipe plays the next song
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: "nextSong:")
        rightSwipe.direction = UISwipeGestureRecognizerDirection.Right
        view.addGestureRecognizer(rightSwipe)
            // Left swipe plays the previous song
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: "previousSong:")
        leftSwipe.direction = UISwipeGestureRecognizerDirection.Left
        view.addGestureRecognizer(leftSwipe)
        

        // Do any additional setup after loading the view.
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
