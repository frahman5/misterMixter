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
    
    convenience init(scHandler: SoundCloudHandler) {
        println("ran custom init")
        self.init()
        self.scHandler = scHandler
        println("@self.schandler: \(self.scHandler)")

    }

//    required init(coder: NSCoder) {
//        super.init(coder: coder)
//    }
//    
    //Code to be removed from your destinationViewController
//    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
//        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
//        // Here you can init your properties
//    }
    
    @IBAction func pause(sender: AnyObject) {
        // send soundCloundHandler the message to pause
        self.scHandler!.pause()
    }

    @IBOutlet var songTitle: UILabel!
    
    func setSongTitle(songTitle: NSString) {
        self.songTitle.text = songTitle
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        println("We opened the right view controller")
        
        

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
