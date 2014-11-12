//
//  SoundCloudHandler.h
//  MASSIVE
//
//  Created by Faiyam Rahman on 10/30/14.
//  Copyright (c) 2014 CornellTech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>


@interface SoundCloudHandler : NSObject

// Interfacing with PlayPageViewController to control audio playback
- (void) playPlaylist:(NSString *) playlistURI;
- (void) nextSong;
- (void) previousSong;
- (void) pause;

// Interfacing with FirstViewController to find the appropriate playlists
- (NSArray *)getPlaylists:(NSArray *)locationArray;

@end
