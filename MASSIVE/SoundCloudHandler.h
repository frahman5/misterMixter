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
- (NSString *)fetchPlaylistsForLocation:(NSString *)location;
- (void) playPlaylist:(NSInteger) whichPlaylist;
- (void) setViewController:(UIViewController *) viewController;
- (void) nextSong;
- (void) previousSong;
- (void) pause;
// create a player object for playerVC
- (void)getAVPlayer;

@end
