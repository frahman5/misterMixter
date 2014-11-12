//
//  SoundCloudHandler.h
//  MASSIVE
//
//  Created by Faiyam Rahman on 10/30/14.
//  Copyright (c) 2014 CornellTech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>                         // UI Access
#import "SCUI.h"                                // soundcloud api
#import <AVFoundation/AVFoundation.h>           // playing audio files


@interface SoundCloudHandler : NSObject

// Interfacing with PlayPageViewController to control audio playback
@property (nonatomic, strong) UIViewController *ppvC;
- (void) playPlaylist:(NSString *) playlistURI;
- (void) nextSong;
- (void) previousSong;
- (void) pause;
- (void) play;

// Interfacing with FirstViewController to find the appropriate playlists
- (void)getPlaylists:(NSArray *)locationArray;



@end
