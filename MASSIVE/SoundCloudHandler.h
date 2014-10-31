//
//  SoundCloudHandler.h
//  MASSIVE
//
//  Created by Faiyam Rahman on 10/30/14.
//  Copyright (c) 2014 CornellTech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface SoundCloudHandler : NSObject
- (NSString *)fetchPlaylistsForLocation:(NSString *)location;
- (void) playPlaylist:(NSInteger) whichPlaylist;
- (void) setViewController:(UIViewController *) viewController;
- (void) pause;
- (void) nextSong;
- (void) previousSong;

@end
