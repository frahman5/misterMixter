//
//  playerVC.swift
//  MASSIVE
//
//  Created by Faiyam Rahman on 11/4/14.
//  Copyright (c) 2014 CornellTech. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class playerVC: AVPlayerViewController {
    
    // the model that handles soundcloud api calls
    var scHandler: SoundCloudHandler!
    
    // the player that contains all our song info
//    var player: AVPlayer!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.player = self.scHandler.getAVPlayer()

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
